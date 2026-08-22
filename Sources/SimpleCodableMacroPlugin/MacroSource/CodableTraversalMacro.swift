import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

struct CodableTraversalMacro: ExtensionMacro {
    static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            throw MacroError("@CodableTraversal can only be applied to enums")
        }

        let enumName = enumDecl.name.text
        let access = declAccessModifier(of: enumDecl)

        let enumCases = enumDecl.memberBlock.members
            .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
            .flatMap { $0.elements }

        var cases: [(caseName: String, typeName: String)] = []
        for ec in enumCases {
            let caseName = ec.name.text
            guard let params = ec.parameterClause?.parameters,
                  params.count == 1,
                  let param = params.first
            else {
                throw MacroError("@CodableTraversal cases must have exactly one associated value")
            }
            cases.append((caseName, param.type.trimmedDescription))
        }

        guard !cases.isEmpty else {
            throw MacroError("@CodableTraversal requires at least one case")
        }

        // MARK: - Decode
        let ifElse = cases.enumerated().map { i, c in
            let kw = i == 0 ? "if" : "} else if"
            return """
            \(kw) let value = try? container.decode(\(c.typeName).self) {
            self = .\(c.caseName)(value)
            """
        }.joined(separator: "\n")
        let decodeBody = """
            let container = try decoder.singleValueContainer()
            \(ifElse)
            } else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Cannot decode \(enumName)"
                )
            }
            """

        // MARK: - Encode
        let encodeCases = cases.map { c in
            "case .\(c.caseName)(let v): try container.encode(v)"
        }.joined(separator: "\n")

        let ext: DeclSyntax = """
            nonisolated extension \(raw: enumName): BaseModel {
                \(raw: access)init(from decoder: Decoder) throws {
                    \(raw: decodeBody)
                }

                \(raw: access)func encode(to encoder: Encoder) throws {
                    var container = encoder.singleValueContainer()
                    switch self {
                    \(raw: encodeCases)
                    }
                }
            }
            """

        guard let extensionDecl = ext.as(ExtensionDeclSyntax.self) else {
            return []
        }
        return [extensionDecl]
    }
}

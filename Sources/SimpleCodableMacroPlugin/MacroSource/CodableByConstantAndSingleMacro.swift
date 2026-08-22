import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

struct CodableByConstantAndSingleMacro: ExtensionMacro {
    static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            throw MacroError("@CodableByConstantAndSingle can only be applied to enums")
        }

        let enumName = enumDecl.name.text
        let access = declAccessModifier(of: enumDecl)

        // Parse parameters
        var field = "type"
        var defaultCaseName: String? = nil

        guard case let .argumentList(args) = node.arguments,
              let singleArg = args.first(where: { $0.label?.text == "singleCase" }),
              let stringLit = singleArg.expression.as(StringLiteralExprSyntax.self),
              let segment = stringLit.segments.first?.as(StringSegmentSyntax.self),
              !segment.content.text.isEmpty
        else {
            throw MacroError("@CodableByConstantAndSingle requires singleCase")
        }
        let singleCaseName = segment.content.text

        if let fieldArg = args.first(where: { $0.label?.text == "field" }),
           let stringLit = fieldArg.expression.as(StringLiteralExprSyntax.self),
           let segment = stringLit.segments.first?.as(StringSegmentSyntax.self) {
            field = segment.content.text
        }
        if let defaultArg = args.first(where: { $0.label?.text == "defaultCase" }),
           let stringLit = defaultArg.expression.as(StringLiteralExprSyntax.self),
           let segment = stringLit.segments.first?.as(StringSegmentSyntax.self) {
            defaultCaseName = segment.content.text
        }

        let enumCases = enumDecl.memberBlock.members
            .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
            .flatMap { $0.elements }

        var regularCases: [(caseName: String, typeName: String)] = []
        var singleEntry: (caseName: String, typeName: String)? = nil
        var fallbackCase: (caseName: String, typeName: String)? = nil

        for ec in enumCases {
            let caseName = ec.name.text
            guard let params = ec.parameterClause?.parameters,
                  params.count == 1,
                  let param = params.first
            else {
                throw MacroError("@CodableByConstantAndSingle cases must have exactly one associated value")
            }
            let entry = (caseName, param.type.trimmedDescription)

            if caseName == singleCaseName {
                singleEntry = entry
            } else if caseName == defaultCaseName {
                fallbackCase = entry
            } else {
                regularCases.append(entry)
            }
        }

        guard !regularCases.isEmpty || fallbackCase != nil else {
            throw MacroError("@CodableByConstantAndSingle requires at least one keyed case or defaultCase")
        }
        
        // MARK: - Single
        guard let singleEntry = singleEntry else {
            throw MacroError("@CodableByConstantAndSingle singleCase must match a case with exactly one associated value")
        }
        let singleType = singleEntry.typeName

        // MARK: - Decode
        let decodeCases = regularCases.map { Case in
            "case \(Case.typeName).\(field): self = .\(Case.caseName)(try c.decode(\(Case.typeName).self))"
        }.joined(separator: "\n")

        let defaultBranch: String
        if let fallback = fallbackCase {
            defaultBranch = "default: self = .\(fallback.caseName)(try c.decode(\(fallback.typeName).self))"
        } else {
            defaultBranch = "default: throw DecodingError.dataCorruptedError(forKey: .\(field), in: container, debugDescription: \"Unknown \(field): \\(field ?? \"null\")\")"
        }
        // MARK: - Encode
        var allCases = regularCases
        if let fallback = fallbackCase {
            allCases.append(fallback)
        }
        if !allCases.contains(where: { $0.caseName == singleEntry.caseName }) {
            allCases.append(singleEntry)
        }

        let encodeCases = allCases.map { Case in
            "case .\(Case.caseName)(let v): try c.encode(v)"
        }.joined(separator: "\n")

        let ext: DeclSyntax = """
            nonisolated extension \(raw: enumName): BaseModel {
                private enum CodingKeys: String, CodingKey { case \(raw: field) }
                \(raw: access)init(from decoder: Decoder) throws {
                    if let singleValue = try? decoder.singleValueContainer(),
                       let value = try? singleValue.decode(\(raw: singleType).self) {
                        self = .\(raw: singleCaseName)(value)
                        return
                    }
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    let field = try container.decodeIfPresent(String.self, forKey: .\(raw: field))
                    let c = try decoder.singleValueContainer()
                    switch field {
                    \(raw: decodeCases)
                    \(raw: defaultBranch)
                    }
                }

                \(raw: access)func encode(to encoder: Encoder) throws {
                    var c = encoder.singleValueContainer()
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

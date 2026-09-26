import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

struct SingleOrArrayMacro: ExtensionMacro {
    static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            throw MacroError("@SingleOrArray can only be applied to enums")
        }

        let enumName = enumDecl.name.text
        let access = declAccessModifier(of: enumDecl)

        // Collect cases with associated values
        let enumCases = enumDecl.memberBlock.members
            .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
            .flatMap { $0.elements }

        guard enumCases.count == 2 else {
            throw MacroError("@SingleOrArray requires exactly two cases")
        }

        // Identify single-value case vs array case
        var singleCase: (name: String, typeName: String)?
        var arrayCase: (name: String, elementType: String)?

        for ec in enumCases {
            let caseName = ec.name.text
            guard let params = ec.parameterClause?.parameters,
                  params.count == 1,
                  let param = params.first
            else {
                throw MacroError("@SingleOrArray cases must have exactly one associated value")
            }

            if let arrType = param.type.as(ArrayTypeSyntax.self) {
                arrayCase = (caseName, arrType.element.trimmedDescription)
            } else {
                singleCase = (caseName, param.type.trimmedDescription)
            }
        }

        guard let single = singleCase, let array = arrayCase else {
            throw MacroError("@SingleOrArray requires one case with a single value and one with an array of the same element type")
        }

        let members = memberNames(of: enumDecl)
        let decodeDecl = members.contains("init(from:)") ? "// Customized By you" : """
            \(access)init(from decoder: any Decoder) throws {
                let container = try decoder.singleValueContainer()
                if (try? container.decode(\(single.typeName).self)) == nil &&
                    (try? container.decode([BaseType].self)) == nil {
                    throw DecodingError.typeMismatch(
                        \(single.typeName).self, .init(
                        codingPath: container.codingPath,
                        debugDescription: "Expected \(single.typeName) or Array[\(array.elementType)]"
                    ))
                }

                if let s = try? container.decode(\(single.typeName).self) {
                    self = .\(single.name)(s)
                    return
                }
                let array = try container.decode([\(array.elementType)].self)
                self = .\(array.name)(array)
            }
            """
        let encodeDecl = members.contains("encode(to:)") ? "// Customized By you" : """
            \(access)func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()
                switch self {
                case .\(single.name)(let v): try container.encode(v)
                case .\(array.name)(let v):  try container.encode(v)
                }
            }
            """
        let ext: DeclSyntax = """
            nonisolated extension \(raw: enumName): BaseModel {
                \(raw: decodeDecl)
                \(raw: encodeDecl)
            }
            """

        guard let extensionDecl = ext.as(ExtensionDeclSyntax.self) else {
            return []
        }
        return [extensionDecl]
    }
}

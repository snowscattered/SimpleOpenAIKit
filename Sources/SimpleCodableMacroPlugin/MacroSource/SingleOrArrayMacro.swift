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

        let ext: DeclSyntax = """
            nonisolated extension \(raw: enumName): BaseModel {
                \(raw: access)init(from decoder: Decoder) throws {
                    let container = try decoder.singleValueContainer()
                    if (try? container.decode(\(raw: single.typeName).self)) == nil &&
                        (try? container.decode([BaseType].self)) == nil {
                        throw DecodingError.typeMismatch(
                            \(raw: single.typeName).self, .init(
                            codingPath: container.codingPath,
                            debugDescription: "Expected \(raw: single.typeName) or Array[\(raw: array.elementType)]"
                        ))
                    }

                    if let s = try? container.decode(\(raw: single.typeName).self) {
                        self = .\(raw: single.name)(s)
                        return
                    }
                    let array = try container.decode([\(raw: array.elementType)].self)
                    self = .\(raw: array.name)(array)
                }
                \(raw: access)func encode(to encoder: Encoder) throws {
                    var container = encoder.singleValueContainer()
                    switch self {
                    case .\(raw: single.name)(let v): try container.encode(v)
                    case .\(raw: array.name)(let v):  try container.encode(v)
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

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

struct CodableStringLiteralWithOtherMacro: ExtensionMacro {
    static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            throw MacroError("@CodableStringLiteralWithOther can only be applied to enums")
        }
        // Collect all case names
        let enumName = enumDecl.name.text
        let access = declAccessModifier(of: enumDecl)
        
        let allElements = enumDecl.memberBlock.members
            .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
            .flatMap { $0.elements }
        let cases = allElements
            .filter { $0.parameterClause == nil }
            .map { $0.name.text }
        guard !cases.isEmpty else {
            throw MacroError("@CodableStringLiteralWithOther requires at least one plain case (e.g. `case a`)")
        }
        guard allElements.contains(where: { $0.name.text == "other" }) else {
            throw MacroError(
                "@CodableStringLiteralWithOther requires `case other(String)`; add it to the enum"
            )
        }
        
        let rawValueCases = cases
            .map { #"case .\#($0): return "\#(unquote(fromCaseName: $0))""# }
            .joined(separator: "\n")
        let decodeCases = cases
            .map { #"case "\#(unquote(fromCaseName: $0))": self = .\#($0)"# }
            .joined(separator: "\n")
        let ext: DeclSyntax = """
            extension \(raw: enumName): BaseModel {
                \(raw: access)var rawValue: String {
                    switch self {
                    \(raw: rawValueCases)
                    case .other(let s): return s
                    }
                }
                \(raw: access)init(from decoder: Decoder) throws {
                    let container = try decoder.singleValueContainer()
                    let rawValue = try container.decode(String.self)
                    switch rawValue {
                    \(raw: decodeCases)
                    default: self = .other(rawValue)
                    }
                }
                \(raw: access)func encode(to encoder: Encoder) throws {
                    var container = encoder.singleValueContainer()
                    try container.encode(rawValue)
                }
            }
            """
        guard let extensionDecl = ext.as(ExtensionDeclSyntax.self) else {
            return []
        }
        
        return [extensionDecl]
    }
}

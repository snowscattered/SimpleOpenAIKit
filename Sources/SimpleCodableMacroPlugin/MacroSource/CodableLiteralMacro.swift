import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

struct CodableLiteralMacro: ExtensionMacro {
    static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        // Validate this is applied to an enum
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            throw MacroError("@CodableLiteral can only be applied to enums")
        }

        let enumName = enumDecl.name.text
        let access = declAccessModifier(of: enumDecl)

        // Extract the raw value type from the inheritance clause
        guard let inheritanceClause = enumDecl.inheritanceClause,
              let firstInherited = inheritanceClause.inheritedTypes.first,
              let rawType = firstInherited.type.as(IdentifierTypeSyntax.self) else {
            throw MacroError("@CodableLiteral requires an enum with a raw value type (e.g. enum Foo: String)")
        }

        let rawTypeName = rawType.name.text

        // Collect all case names
        let cases = enumDecl.memberBlock.members
            .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
            .flatMap { $0.elements.map { $0.rawValue?.value.trimmedDescription ?? $0.name.text } }

        // Build the expected values string for the error message, e.g. ["float", "base64"]
        let expectedValues = cases.map { #""\#($0)""# }.joined(separator: ", ")

        let initFromSyntax: DeclSyntax = """
            \(raw: access)init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                let rawValue = try container.decode(\(raw: rawTypeName).self)
                guard let value = Self(rawValue: rawValue) else {
                    throw DecodingError.dataCorruptedError(
                        in: container,
                        debugDescription: #"Expected Literal[\(raw: expectedValues)] but got \\#(rawValue)"#
                    )
                }
                self = value
            }
            """

        let ext: DeclSyntax = """
            extension \(raw: enumName): BaseModel {
                \(initFromSyntax)
            }
            """

        guard let extensionDecl = ext.as(ExtensionDeclSyntax.self) else {
            return []
        }

        return [extensionDecl]
    }
}

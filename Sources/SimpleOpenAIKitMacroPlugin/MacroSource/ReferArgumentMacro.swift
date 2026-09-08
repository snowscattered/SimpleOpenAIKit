import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Generates an object schema for the struct annotated with `@ReferArgument`, without a nested `$def`.
struct ReferArgumentMacro: MemberMacro, ExtensionMacro {
    static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        conformanceExtension(of: type, to: "ReferArgument")
    }

    static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw MacroError("@ReferArgument can only be applied to structs")
        }

        return [argumentSchemaMember(
            access: accessPrefix(of: structDecl.modifiers),
            schema: objectSchema(of: storedProperties(of: structDecl), includesDefinitions: false)
        )]
    }
}

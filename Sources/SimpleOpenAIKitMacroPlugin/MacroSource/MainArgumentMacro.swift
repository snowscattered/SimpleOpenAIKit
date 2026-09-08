import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Generates the root object schema for the struct annotated with `@MainArgument`.
struct MainArgumentMacro: MemberMacro, ExtensionMacro {
    static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        conformanceExtension(of: type, to: "MainArgument")
    }

    static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw MacroError("@MainArgument can only be applied to structs")
        }
        let extra = node.arguments?.as(LabeledExprListSyntax.self)?
            .first { $0.label?.text == "extra" }?.expression.trimmedDescription

        return [argumentSchemaMember(
            access: accessPrefix(of: structDecl.modifiers),
            schema: objectSchema(of: storedProperties(of: structDecl)),
            extra: extra
        )]
    }
}

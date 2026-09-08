import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Generates `ArgumentSchema` for the struct annotated with `@ReferArgument`: the `object` schema
/// `@MainArgument` writes, keyed by the name of the type itself so that it reads as a `$def` entry. The
/// struct also adopts `ReferArgument`.
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
            throw ToolMacroError("@ReferArgument can only be applied to structs")
        }

        let properties = storedProperties(of: structDecl)

        // The key is what a `$ref` writes after `#/$def/`, so it is the type's own name. The definitions
        // this one references are merged beside that entry rather than into a `$def` of their own, so a
        // use site only has to merge this map to hold every `$ref` it can reach.
        let schema = SchemaSource.dictionary([
            (key: structDecl.name.text, value: .dictionary(objectEntries(of: properties))),
        ])
        return [argumentSchemaMember(
            access: accessPrefix(of: structDecl.modifiers),
            schema: schema,
            merging: referencedDefinitionsExpression(of: properties.map { ($0.baseTypeName, $0.argument) })
        )]
    }
}

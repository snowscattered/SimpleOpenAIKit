import SwiftSyntax
import SwiftSyntaxMacros

/// A marker macro that declares the JSON key names a stored property answers to.
/// Produces no code — `@BaseModelWithExtra` and `@BaseModelNoWithExtra` read the annotation
/// while generating their `CodingKeys` cases and decoding statements.
struct BaseModelFieldAliasMacro: PeerMacro {
    static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let binding = declaration.as(VariableDeclSyntax.self)?.bindings.first,
              binding.pattern.is(IdentifierPatternSyntax.self),
              binding.accessorBlock == nil,
              binding.typeAnnotation != nil
        else {
            throw MacroError("@BaseModelFieldAlias can only be applied to a stored property")
        }

        _ = try stringLiteralArguments(from: node, label: "BaseModelFieldAlias")
        return []
    }
}

import SwiftSyntax
import SwiftSyntaxMacros

/// A marker macro applied to stored properties. Produces no code —
/// used by `@BaseModelWithExtra` to skip encoding for the annotated property.
struct TransientMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // Intentionally empty — serves only as a marker attribute.
        []
    }
}

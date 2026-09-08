import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Describes a `boolean` value, which has no constraint beyond `description`.
struct BooleanToolArgumentMacro: PeerMacro {
    /// The marker generates no code; it only rejects a value of a wrong Swift type.
    static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        try validateToolArgument(in: declaration, macroName: "BooleanToolArgument", as: .boolean)
        return []
    }

    static func schema(typeName: String, _ argument: ToolArgument) -> SchemaSource {
        var entries: [(key: String, value: SchemaSource)] = [("type", .literal("\"boolean\""))]
        entries += argument.descriptionEntries()
        return .dictionary(entries)
    }
}

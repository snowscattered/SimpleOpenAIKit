import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Describes a `string` value. Strict mode checks `pattern` and `format`; `minLength` and `maxLength`
/// belong to JSON Schema but are not supported in strict mode.
struct StringToolArgumentMacro: PeerMacro {
    /// The marker generates no code: `@MainArgument` and `@AnyOfToolArgument` read the attribute and ask
    /// `schema(typeName:_:)` for the value. This is where a wrong one is rejected.
    static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        try validateToolArgument(in: declaration, macroName: "StringToolArgument", as: .string)
        return []
    }

    static func schema(typeName: String, _ argument: ToolArgument) -> SchemaSource {
        var entries: [(key: String, value: SchemaSource)] = [("type", .literal("\"string\""))]
        entries += argument.descriptionEntries()
        entries += argument.values("format", "pattern", "minLength", "maxLength")
        return .dictionary(entries)
    }
}

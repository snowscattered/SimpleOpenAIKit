import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Describes a `number` value, or an `integer` one when the Swift type is integral. The keys are the
/// ones strict mode lists for `number`/`integer`.
struct NumberToolArgumentMacro: PeerMacro {
    /// The marker generates no code; it only rejects a value of a wrong Swift type.
    static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        try validateToolArgument(in: declaration, macroName: "NumberToolArgument", as: .number)
        return []
    }

    static func schema(typeName: String, _ argument: ToolArgument) -> SchemaSource {
        let type = scalarType(optionTypeName(typeName)) == "integer" ? "integer" : "number"
        var entries: [(key: String, value: SchemaSource)] = [("type", .literal("\"\(type)\""))]
        entries += argument.descriptionEntries()
        entries += argument.values("default", "minimum", "maximum", "exclusiveMinimum", "exclusiveMaximum", "multipleOf")
        return .dictionary(entries)
    }
}

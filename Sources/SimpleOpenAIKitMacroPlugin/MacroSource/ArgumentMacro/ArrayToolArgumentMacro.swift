import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Describes an `array` value. `items` is the schema inferred from the Swift element type; `minItems`
/// and `maxItems` belong to JSON Schema but are not supported in strict mode.
struct ArrayToolArgumentMacro: PeerMacro {
    /// The marker generates no code; it only rejects a value of a wrong Swift type.
    static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        try validateToolArgument(in: declaration, macroName: "ArrayToolArgument", as: .array)
        return []
    }

    static func schema(typeName: String, _ argument: ToolArgument) -> SchemaSource {
        var entries: [(key: String, value: SchemaSource)] = [("type", .literal("\"array\""))]
        entries += argument.descriptionEntries()
        let items = arrayElementTypeName(typeName).map { inferredSchema(forTypeName: $0) }
            ?? inferredSchema(forTypeName: typeName)
        entries.append(("items", items))
        entries += argument.values("minItems", "maxItems")
        return .dictionary(entries)
    }
}

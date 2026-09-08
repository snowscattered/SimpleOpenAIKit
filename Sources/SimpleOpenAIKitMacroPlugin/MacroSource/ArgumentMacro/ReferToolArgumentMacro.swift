import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Describes a value by reference: `{"$ref": "#/$def/TypeName"}` pointing at a type annotated with
/// `@ArgumentSchema`, whose definition the enclosing schema carries in its `$def`. An array of them keeps
/// its own `type` and `description` and references the definition inside `items`.
struct ReferToolArgumentMacro: PeerMacro {
    /// The marker generates no code; it only rejects a value of a wrong Swift type.
    static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        try validateToolArgument(in: declaration, macroName: "ReferToolArgument", as: .reference)
        return []
    }

    static func schema(typeName: String, _ argument: ToolArgument) -> SchemaSource {
        guard let definition = referencedTypeName(typeName) else {
            return inferredSchema(forTypeName: typeName)
        }
        // A nested type is spelled `Outer.Inner` at the use site but defined under `Inner`.
        let name = referencedDefinitionName(definition)
        let reference: (key: String, value: SchemaSource) = ("$ref", .literal("\"#/$def/\(name)\""))
        // The definition of an array is `items`, which describes a value of its own.
        guard arrayElementTypeName(optionTypeName(typeName)) == nil else {
            var entries: [(key: String, value: SchemaSource)] = [("type", .literal("\"array\""))]
            entries += argument.descriptionEntries()
            entries.append(("items", .dictionary([reference])))
            return .dictionary(entries)
        }
        var entries: [(key: String, value: SchemaSource)] = [reference]
        entries += argument.descriptionEntries()
        return .dictionary(entries)
    }
}

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Describes a value with the `description` key every JSON Schema fragment may carry. The marker
/// generates no code: `@MainArgument`, `@ReferArgument` and `@AnyOfToolArgument` read the attribute and
/// write the entry next to the schema of the value it describes, whether that schema is inferred from
/// the Swift type or built by a `@*ToolArgument` marker.
struct ArgumentDescriptionMacro: PeerMacro {
    /// The attribute name, spelled in one place for the reader and for the diagnostics.
    static let name = "ArgumentDescription"

    static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        _ = try describedValues(in: declaration, macroName: Self.name)
        return []
    }

    /// The description source written in `attributes`, or `nil` when there is none or it is spelled as
    /// an empty string. The source stays text so that a literal reaches the generated schema untouched.
    static func source(in attributes: AttributeListSyntax) -> String? {
        guard let attribute = attributes.lazy
            .compactMap({ $0.as(AttributeSyntax.self) })
            .first(where: { $0.attributeName.as(IdentifierTypeSyntax.self)?.name.text == Self.name }),
            let source = attribute.arguments?.as(LabeledExprListSyntax.self)?.first?.expression.trimmedDescription,
            source != "\"\""
        else {
            return nil
        }
        return source
    }

    /// The `description` entry for `source`, none when there is no description.
    static func entries(for source: String?) -> [(key: String, value: SchemaSource)] {
        guard let source else { return [] }
        return [("description", .literal(source))]
    }
}

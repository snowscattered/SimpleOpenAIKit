import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// The source of a labelled macro argument, or `nil` when the argument is missing, spelled `nil` or
/// written as an empty string. Both spellings mean "not provided", so the member falls back.
private func providedSource(_ arguments: LabeledExprListSyntax?, _ label: String) -> String? {
    guard let source = arguments?.first(where: { $0.label?.text == label })?.expression.trimmedDescription else {
        return nil
    }
    let written = source.filter { !$0.isWhitespace }
    guard written != "nil", written != "\"\"" else { return nil }
    return source
}

/// Generates the root object schema for the struct annotated with `@MainSchema`, plus the members
/// `SchemaProtocol` asks for: `name` taken from the type's own name, `typealias Arguments = Self`,
/// which makes the struct its own payload type, and `description` and `strict`, written as `nil` when
/// the caller leaves them out. The conformance itself is declared on the struct, so the macro only
/// adds `MainArgument`.
struct MainSchemaMacro: MemberMacro, ExtensionMacro {
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
            throw MacroError("@MainSchema can only be applied to structs")
        }
        let access = accessPrefix(of: structDecl.modifiers)
        let arguments = node.arguments?.as(LabeledExprListSyntax.self)
        let extra = arguments?.first(where: { $0.label?.text == "extra" })?.expression.trimmedDescription

        return [
            argumentSchemaMember(
                access: access,
                schema: objectSchema(of: storedProperties(of: structDecl)),
                extra: extra
            ),
            "\(raw: access)typealias Arguments = Self",
            "\(raw: access)static let name: String = \(raw: String(reflecting: structDecl.name.text))",
            "\(raw: access)static let description: String? = \(raw: providedSource(arguments, "description") ?? "nil")",
            "\(raw: access)static let strict: Bool? = \(raw: providedSource(arguments, "strict") ?? "nil")",
        ]
    }
}

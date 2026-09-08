import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Generates `ArgumentSchema` as `{"type": ..., "enum": [...]}` for the scalar-backed enum annotated
/// with `@EnumToolArgument`, built from the raw values of its cases. The enum also adopts `EnumArgument`.
struct EnumToolArgumentMacro: MemberMacro, ExtensionMacro {
    static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        conformanceExtension(of: type, to: "EnumArgument")
    }

    static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            throw MacroError("@EnumToolArgument can only be applied to enums")
        }
        // Swift raw enums support string and numeric raw values, not `Bool`.
        guard let rawType = enumDecl.inheritanceClause?.inheritedTypes.first?.type.trimmedDescription,
              let jsonType = scalarType(rawType),
              jsonType != "boolean"
        else {
            throw MacroError("@EnumToolArgument needs a raw type such as `String`, `Int`, `Double` or `Float`")
        }

        // Every raw value, as source text. Swift continues an implicit raw value from the case before it,
        // so an explicit one moves the counter. Only `String` and `Int` get implicit ones, and a `String`
        // case falls back to its own name.
        var values: [String] = []
        var nextValue = 0
        for member in enumDecl.memberBlock.members {
            guard let caseDecl = member.decl.as(EnumCaseDeclSyntax.self) else { continue }
            for element in caseDecl.elements {
                guard let raw = element.rawValue?.value.trimmedDescription else {
                    switch jsonType {
                    case "string": values.append(String(reflecting: element.name.text))
                    case "number": values.append("\(nextValue).0")
                    default:       values.append("\(nextValue)")
                    }
                    nextValue += 1
                    continue
                }
                values.append(raw)
                if let explicit = Int(raw) { nextValue = explicit + 1 }
            }
        }

        let schema = SchemaSource.dictionary([
            ("type", .literal("\"\(jsonType)\"")),
            ("enum", .array(values.map { .literal($0) })),
        ])
        return [argumentSchemaMember(access: accessPrefix(of: enumDecl.modifiers), schema: schema)]
    }
}

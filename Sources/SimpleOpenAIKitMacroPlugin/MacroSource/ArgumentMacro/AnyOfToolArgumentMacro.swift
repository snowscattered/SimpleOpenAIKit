import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Generates `ArgumentSchema` as `{"anyOf": [...]}` for the enum annotated with `@AnyOfToolArgument`:
/// every case contributes the schema of its associated value, together with the `@*ToolArgument` marker
/// the case carries, if any. The enum also adopts `AnyOfArgument`.
struct AnyOfToolArgumentMacro: MemberMacro, ExtensionMacro {
    static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        conformanceExtension(of: type, to: "AnyOfArgument")
    }

    static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            throw MacroError("@AnyOfToolArgument can only be applied to enums")
        }

        var branches: [SchemaSource] = []
        var caseValues: [(typeName: String, argument: ToolArgument?)] = []
        for member in enumDecl.memberBlock.members {
            guard let caseDecl = member.decl.as(EnumCaseDeclSyntax.self) else { continue }

            // The `@*ToolArgument` marker the case carries, if any. Values stay source text so that
            // literals reach the generated schema untouched.
            let argument = ToolArgument(attributes: caseDecl.attributes)
            let type = try associatedValueType(of: caseDecl)

            let typeName = type.trimmedDescription
            branches.append(valueSchema(typeName: typeName, argument: argument))
            caseValues.append((typeName, argument))
        }
        guard !branches.isEmpty else {
            throw MacroError("@AnyOfToolArgument requires at least one case")
        }

        // A branch that references a definition has to travel with it, since a `$ref` only resolves
        // together with the definition it points at.
        var entries: [(key: String, value: SchemaSource)] = [("anyOf", .array(branches))]
        if let definitions = referencedDefinitionsSchema(of: caseValues) {
            entries.append(("$def", definitions))
        }
        return [argumentSchemaMember(
            access: accessPrefix(of: enumDecl.modifiers),
            schema: .dictionary(entries)
        )]
    }

    /// Returns the type of the single associated value carried by `caseDecl`.
    private static func associatedValueType(of caseDecl: EnumCaseDeclSyntax) throws -> TypeSyntax {
        guard caseDecl.elements.count == 1,
              let element = caseDecl.elements.first,
              let parameters = element.parameterClause?.parameters,
              parameters.count == 1,
              let type = parameters.first?.type
        else {
            throw MacroError("@AnyOfToolArgument cases must carry exactly one associated value")
        }

        return type
    }
}

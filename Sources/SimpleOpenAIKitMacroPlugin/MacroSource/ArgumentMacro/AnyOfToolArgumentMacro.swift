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
        var caseValues: [(caseName: String, typeName: String, argument: ToolArgument?)] = []
        var seenTypes: [String: (caseName: String, typeName: String)] = [:]
        for member in enumDecl.memberBlock.members {
            guard let caseDecl = member.decl.as(EnumCaseDeclSyntax.self) else { continue }

            // The `@*ToolArgument` marker the case carries, if any. Values stay source text so that
            // literals reach the generated schema untouched.
            let argument = ToolArgument(attributes: caseDecl.attributes)
            let value = try associatedValue(of: caseDecl)

            let typeName = value.type.trimmedDescription
            let typeKey = optionTypeName(typeName)
            if let previous = seenTypes[typeKey] {
                throw MacroError(
                    "@AnyOfToolArgument cannot distinguish `\(previous.caseName): \(previous.typeName)` from `\(value.caseName): \(typeName)`"
                )
            }
            seenTypes[typeKey] = (value.caseName, typeName)
            branches.append(valueSchema(typeName: typeName, argument: argument))
            caseValues.append((value.caseName, typeName, argument))
        }
        guard !branches.isEmpty else {
            throw MacroError("@AnyOfToolArgument requires at least one case")
        }

        // A branch that references a definition has to travel with it, since a `$ref` only resolves
        // together with the definition it points at.
        var entries: [(key: String, value: SchemaSource)] = [("anyOf", .array(branches))]
        if let definitions = referencedDefinitionsSchema(
            of: caseValues.map { ($0.typeName, $0.argument) }
        ) {
            entries.append(("$def", definitions))
        }
        return [
            argumentSchemaMember(
                access: accessPrefix(of: enumDecl.modifiers),
                schema: .dictionary(entries)
            ),
            Self.anyOfDecodableMember(
                access: accessPrefix(of: enumDecl.modifiers),
                enumName: enumDecl.name.text,
                cases: caseValues.map { ($0.caseName, $0.typeName) }
            ),
        ]
    }

    /// Returns the name and type of the single associated value carried by `caseDecl`.
    private static func associatedValue(
        of caseDecl: EnumCaseDeclSyntax
    ) throws -> (caseName: String, type: TypeSyntax) {
        guard caseDecl.elements.count == 1,
              let element = caseDecl.elements.first,
              let parameters = element.parameterClause?.parameters,
              parameters.count == 1,
              let type = parameters.first?.type
        else {
            throw MacroError("@AnyOfToolArgument cases must carry exactly one associated value")
        }

        return (element.name.text, type)
    }

    /// Generates the `Decodable` initializer for an `anyOf` enum argument.
    private static func anyOfDecodableMember(
        access: String,
        enumName: String,
        cases: [(caseName: String, typeName: String)]
    ) -> DeclSyntax {
        let branches = cases.enumerated().map { index, value in
            let keyword = index == 0 ? "if" : "} else if"
            return """
                \(keyword) let value = try? container.decode(\(value.typeName).self) {
                    self = .\(value.caseName)(value)
                """
        }.joined(separator: "\n")

        let errorDescription = "Cannot decode \(enumName)"
        let member: DeclSyntax = """
            nonisolated \(raw: access)init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                \(raw: branches)
                } else {
                    throw DecodingError.dataCorruptedError(
                        in: container,
                        debugDescription: "\(raw: errorDescription)"
                    )
                }
            }
            """
        return member
    }
}

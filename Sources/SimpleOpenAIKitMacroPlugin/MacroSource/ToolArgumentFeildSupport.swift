import SwiftSyntax

// MARK: - Type names

/// A Swift type name with every level of `Optional` removed, so that every reader looks at the same
/// type a schema is built from.
package func optionTypeName(_ typeName: String) -> String {
    if typeName.hasSuffix("?") { return optionTypeName(String(typeName.dropLast())) }
    if typeName.hasPrefix("Optional<"), typeName.hasSuffix(">") {
        return optionTypeName(String(typeName.dropFirst(9).dropLast()))
    }
    return typeName
}

/// The element type of an array-like Swift type name, when it is one.
package func arrayElementTypeName(_ typeName: String) -> String? {
    guard typeName.hasPrefix("["), typeName.hasSuffix("]"), !typeName.contains(":") else { return nil }
    return String(typeName.dropFirst().dropLast())
}

/// The named type a value's type is built from, with every level of `Optional` and of `array`
/// unwrapped, or `nil` when what is left is a scalar or a collection the macros do not describe.
package func referencedTypeName(_ typeName: String) -> String? {
    var name = optionTypeName(typeName)
    while let element = arrayElementTypeName(name) { name = optionTypeName(element) }
    guard !name.hasPrefix("["), !name.hasPrefix("(") else { return nil }
    return scalarType(name) == nil ? name : nil
}

/// The types the values reference with `@ReferToolArgument`, in order and without repetition. An array
/// references its element type.
package func referencedTypeNames(of values: [(typeName: String, argument: ToolArgument?)]) -> [String] {
    var names: [String] = []
    for value in values where value.argument?.kind == .reference {
        guard let name = referencedTypeName(value.typeName), !names.contains(name) else { continue }
        names.append(name)
    }
    return names
}

/// The last component of a referenced type name, which is the key used by `$ref`.
package func referencedDefinitionName(_ typeName: String) -> String {
    typeName.split(separator: ".").last.map(String.init) ?? typeName
}

/// The `$def` dictionary for every referenced type, or `nil` when there are none.
package func referencedDefinitionsSchema(
    of values: [(typeName: String, argument: ToolArgument?)]
) -> SchemaSource? {
    let names = referencedTypeNames(of: values)
    guard !names.isEmpty else { return nil }
    return .dictionary(names.map { name in
        (
            key: referencedDefinitionName(name),
            value: .literal(".dict(\(name).ArgumentSchema)")
        )
    })
}

/// The JSON type of a scalar Swift type name, `nil` when it is not a scalar.
package func scalarType(_ typeName: String) -> String? {
    switch typeName {
    case "String", "Substring": return "string"
    case "Int", "Int8", "Int16", "Int32", "Int64",
         "UInt", "UInt8", "UInt16", "UInt32", "UInt64": return "integer"
    case "Double", "Float", "Float80", "Decimal": return "number"
    case "Bool": return "boolean"
    default: return nil
    }
}

// MARK: - Tool argument

/// The marker attached to a value to describe its schema.
package enum ToolArgumentKind: String {
    case string = "StringToolArgument"
    case number = "NumberToolArgument"
    case boolean = "BooleanToolArgument"
    case array = "ArrayToolArgument"
    case reference = "ReferToolArgument"

    /// Whether this marker accepts the Swift type written by the user.
    func accepts(typeName: String) -> Bool {
        switch self {
        case .string:
            return scalarType(typeName) == "string"
        case .number:
            let scalar = scalarType(typeName)
            return scalar == "number" || scalar == "integer"
        case .boolean:
            return scalarType(typeName) == "boolean"
        case .array:
            return arrayElementTypeName(typeName) != nil
        case .reference:
            return referencedTypeName(typeName) != nil
        }
    }

    /// The value description used in diagnostics.
    var expectedDescription: String {
        switch self {
        case .string: return "a `string` value"
        case .number: return "a `number` or `integer` value"
        case .boolean: return "a `boolean` value"
        case .array: return "an `array` value"
        case .reference: return "a value whose type is a @ReferArgument definition"
        }
    }
}

/// A `@*ToolArgument` marker and the arguments it carries. Values stay source text so that literals
/// reach the generated schema untouched.
package struct ToolArgument {
    package let kind: ToolArgumentKind
    package let arguments: [String: String]

    package init(kind: ToolArgumentKind, arguments: [String: String]) {
        self.kind = kind
        self.arguments = arguments
    }

    /// The entries for `labels`, in the given order, skipping the ones that are not spelled out.
    package func values(_ labels: String...) -> [(key: String, value: SchemaSource)] {
        labels.compactMap { label in arguments[label].map { (key: label, value: .literal($0)) } }
    }

    /// The `description` entry, when there is a non-empty one.
    package func descriptionEntries() -> [(key: String, value: SchemaSource)] {
        guard let value = arguments["description"], value != "\"\"" else { return [] }
        return [("description", .literal(value))]
    }
}

extension ToolArgument {
    /// Builds an argument from the first schema marker in `attributes`, if one is present.
    package init?(attributes: AttributeListSyntax) {
        guard let marker = Self.marker(in: attributes),
              let name = marker.attributeName.as(IdentifierTypeSyntax.self)?.name.text,
              let kind = ToolArgumentKind(rawValue: name)
        else {
            return nil
        }

        var arguments: [String: String] = [:]
        if let list = marker.arguments?.as(LabeledExprListSyntax.self) {
            for labeled in list {
                guard let label = labeled.label?.text else { continue }
                // A keyword label keeps the backticks it was written with, e.g. `default`.
                arguments[label.filter { $0 != "`" }] = labeled.expression.trimmedDescription
            }
        }

        self.init(kind: kind, arguments: arguments)
    }

    private static func marker(in attributes: AttributeListSyntax) -> AttributeSyntax? {
        attributes.lazy
            .compactMap { $0.as(AttributeSyntax.self) }
            .first {
                guard let name = $0.attributeName.as(IdentifierTypeSyntax.self)?.name.text else {
                    return false
                }
                return ToolArgumentKind(rawValue: name) != nil
            }
    }
}

/// The values described by a property or enum case, together with their Swift type names.
package func describedValues(
    in declaration: some DeclSyntaxProtocol,
    macroName: String
) throws -> [(name: String, typeName: String)] {
    if let varDecl = declaration.as(VariableDeclSyntax.self) {
        return varDecl.bindings.compactMap { binding in
            guard let name = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
                  let type = binding.typeAnnotation?.type.trimmedDescription
            else { return nil }
            return (name: name, typeName: optionTypeName(type))
        }
    }

    if let caseDecl = declaration.as(EnumCaseDeclSyntax.self) {
        return caseDecl.elements.flatMap { element in
            element.parameterClause?.parameters.map {
                (name: element.name.text, typeName: optionTypeName($0.type.trimmedDescription))
            } ?? []
        }
    }

    throw MacroError("@\(macroName) can only be applied to a property or an enum case")
}

/// Checks that every value described by `declaration` matches the marker's JSON type.
package func validateToolArgument(
    in declaration: some DeclSyntaxProtocol,
    macroName: String,
    as kind: ToolArgumentKind
) throws {
    for value in try describedValues(in: declaration, macroName: macroName) {
        guard !kind.accepts(typeName: value.typeName) else { continue }
        throw MacroError(
            "@\(macroName) describes \(kind.expectedDescription), not `\(value.name): \(value.typeName)`"
        )
    }
}

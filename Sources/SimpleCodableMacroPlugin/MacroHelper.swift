import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

// MARK: - Property model
package struct StoredProperty {
    let name: String
    let typeName: String
    let isOptional: Bool
    let isTransient: Bool
    let isStatic: Bool
    let isImmutableWithDefault: Bool
    let isMutable: Bool
    let defaultValue: String?
    let aliasKeys: [String]
}

package struct TypeOptionality {
    let name: String
    let isOptional: Bool
}

// MARK: - Coding key model
/// The `CodingKeys` cases that carry one stored property's JSON names.
package struct FieldCodingKeys {
    let cases: [String]
    let wireKeys: [String]
}

/// How the `@BaseModel*` macros lay out `CodingKeys` for a set of stored properties.
package struct CodingKeysPlan {
    let caseLines: [String]
    let byProperty: [String: FieldCodingKeys]

    /// The key shape a generated decode call uses for `prop`.
    fileprivate func keyPlan(for prop: StoredProperty) -> DecodingKeyPlan {
        guard let keys = byProperty[prop.name], keys.cases.count > 1 else {
            return .single(prop.name)
        }
        return .aliases(keys.cases)
    }
}

fileprivate enum DecodingKeyPlan {
    case single(String)
    case aliases([String])

    var source: String {
        switch self {
        case .single(let key):
            return "forKey: .\(key)"
        case .aliases(let keys):
            return "aliasCases: [\(keys.map { ".\($0)" }.joined(separator: ", "))]"
        }
    }
}

// MARK: - Syntax helpers
package func declAccessModifier(of decl: some DeclGroupSyntax) -> String {
    for modifier in decl.modifiers {
        switch modifier.name.tokenKind {
        case .keyword(.public):  return "public "
        case .keyword(.package): return "package "
        default: break
        }
    }
    return ""
}

package func unquote(fromCaseName name: String) -> String {
    guard name.hasPrefix("`"), name.hasSuffix("`"), name.count >= 2 else {
        return name
    }
    return String(name.dropFirst().dropLast())
}

// MARK: - Attribute parsing
private func markerAttributes(named name: String, in attributes: AttributeListSyntax) -> [AttributeSyntax] {
    attributes.compactMap { $0.as(AttributeSyntax.self) }.filter {
        $0.attributeName.trimmedDescription.split(separator: ".").last.map(String.init) == name
    }
}

private func flattenedAttributeArguments(
    from attribute: AttributeSyntax,
    label: String,
    requirement: String = "value"
) throws -> [ExprSyntax] {
    guard case let .argumentList(arguments) = attribute.arguments, !arguments.isEmpty else {
        throw MacroError("@\(label) requires at least one \(requirement)")
    }

    let expressions: [ExprSyntax]
    if arguments.count == 1,
       let values = arguments.first?.expression.as(ArrayExprSyntax.self) {
        expressions = values.elements.map { $0.expression }
    } else {
        expressions = arguments.map { $0.expression }
    }

    guard !expressions.isEmpty else {
        throw MacroError("@\(label) requires at least one \(requirement)")
    }
    return expressions
}

/// Read the string literals passed to a marker attribute, accepting both `("a", "b")` and `(["a", "b"])`.
package func stringLiteralArguments(from attribute: AttributeSyntax, label: String) throws -> [String] {
    let expressions = try flattenedAttributeArguments(from: attribute, label: label, requirement: "key")
    return try expressions.map { expression in
        guard let literal = expression.as(StringLiteralExprSyntax.self),
              literal.segments.count == 1,
              let segment = literal.segments.first?.as(StringSegmentSyntax.self)
        else { throw MacroError("@\(label) only accepts plain string literals") }
        return segment.content.text
    }
}

// MARK: - Property collection
/// The JSON keys `@BaseModelFieldAlias` declares for a stored property.
/// Malformed arguments are reported by the marker macro itself, so this stays non-throwing.
package func fieldAliasKeys(of varDecl: VariableDeclSyntax) -> [String] {
    guard let attribute = markerAttributes(named: "BaseModelFieldAlias", in: varDecl.attributes).first else {
        return []
    }
    let keys = (try? stringLiteralArguments(from: attribute, label: "BaseModelFieldAlias")) ?? []
    return keys.filter { !$0.isEmpty }
}

package func collectStoredProperties(of declaration: some DeclGroupSyntax) -> [StoredProperty] {
    declaration.memberBlock.members.flatMap { member -> [StoredProperty] in
        guard let varDecl = member.decl.as(VariableDeclSyntax.self) else { return [] }

        let bindingKind = varDecl.bindingSpecifier.tokenKind
        guard bindingKind == .keyword(.let) || bindingKind == .keyword(.var) else { return [] }

        let isTransient = !markerAttributes(named: "transient", in: varDecl.attributes).isEmpty
        let isStatic = varDecl.modifiers.contains(where: { $0.name.tokenKind == .keyword(.static) })
        let isMutable = bindingKind == .keyword(.var)

        return varDecl.bindings.compactMap { binding in
            guard binding.accessorBlock == nil,
                  let pattern = binding.pattern.as(IdentifierPatternSyntax.self),
                  let typeAnnotation = binding.typeAnnotation
            else { return nil }

            let type = typeAnnotation.type.as(OptionalTypeSyntax.self)
                .map { TypeOptionality(name: $0.wrappedType.trimmedDescription, isOptional: true) }
                ?? TypeOptionality(name: typeAnnotation.type.trimmedDescription, isOptional: false)

            return StoredProperty(
                name: pattern.identifier.text,
                typeName: type.name,
                isOptional: type.isOptional,
                isTransient: isTransient,
                isStatic: isStatic,
                isImmutableWithDefault: !isMutable && binding.initializer != nil,
                isMutable: isMutable,
                defaultValue: binding.initializer?.value.trimmedDescription,
                aliasKeys: fieldAliasKeys(of: varDecl)
            )
        }
    }
}

// MARK: - Coding key naming
/// A name usable as an enum case as it is: identifier characters, no leading digit, no keyword.
private func isPlainCaseName(_ name: String) -> Bool {
    let swiftKeywords: Set<String> = [
        "associatedtype", "async", "await", "break", "case", "catch", "class", "continue",
        "convenience", "default", "defer", "deinit", "do", "each", "else", "enum", "extension",
        "fallthrough", "false", "fileprivate", "final", "for", "func", "get", "guard", "if",
        "import", "in", "init", "inout", "internal", "is", "let", "nil", "nonisolated",
        "operator", "package", "private", "protocol", "public", "repeat", "rethrows", "return",
        "self", "set", "some", "static", "struct", "subscript", "super", "throw", "throws",
        "true", "try", "where", "while",
    ]
    guard let first = name.first, (first.isLetter || first == "_"), !swiftKeywords.contains(name)
    else { return false }
    return name.allSatisfy { $0.isLetter || $0.isNumber || $0 == "_" }
}

/// The `CodingKeys` case name carrying the JSON key `key`, readable as close to the key as Swift allows.
private func caseName(for key: String) -> String {
    if isPlainCaseName(key) { return key }
    if key.contains(where: { $0.isLetter || $0 == "_" })
        && key.allSatisfy({ $0.isLetter || $0.isNumber || $0 == "_" || $0 == "-" }) {
        return "`\(key)`"
    }
    var mangled = String(key.map { $0.isLetter || $0.isNumber || $0 == "_" ? $0 : "_" })
    if let first = mangled.first, !first.isLetter && first != "_" { mangled = "_" + mangled }
    guard !mangled.isEmpty else { return "__" }
    return isPlainCaseName(mangled) ? mangled : "`\(mangled)`"
}

/// Claim `name` for one case, suffixing it when another property already took that spelling.
private func claimCaseName(_ name: String, taken: inout Set<String>) -> String {
    var candidate = name
    while taken.contains(candidate) {
        let bare = unquote(fromCaseName: candidate) + "_"
        candidate = isPlainCaseName(bare) ? bare : "`\(bare)`"
    }
    taken.insert(candidate)
    return candidate
}

// MARK: - Codable generation
/// Plan the `CodingKeys` cases for `stored`: one case per JSON key, named after the key itself, so an
/// aliased field reads as `case beta_realtime` or a backticked hyphenated case rather than an opaque
/// counter. Encoding always writes the Swift property name, which therefore leads the decode list;
/// `@BaseModelFieldAlias` only adds the extra spellings the field also answers to when decoding.
package func codingKeysPlan(of stored: [StoredProperty]) throws -> CodingKeysPlan {
    var caseLines: [String] = []
    var byProperty: [String: FieldCodingKeys] = [:]
    var taken: Set<String> = []
    var ownerByKey: [String: String] = [:]

    for prop in stored {
        let name = unquote(fromCaseName: prop.name)

        var wireKeys = [name]
        for key in prop.aliasKeys where !wireKeys.contains(key) { wireKeys.append(key) }
        for key in wireKeys {
            guard let other = ownerByKey[key] else { ownerByKey[key] = name; continue }
            throw MacroError("@BaseModelFieldAlias: key \"\(key)\" is claimed by both \(other) and \(name)")
        }
        var cases = [prop.name]
        taken.insert(prop.name)
        caseLines.append("case \(prop.name)")

        for key in wireKeys.dropFirst() {
            let caseName = claimCaseName(caseName(for: key), taken: &taken)
            cases.append(caseName)
            caseLines.append(unquote(fromCaseName: caseName) == key ? "case \(caseName)" : "case \(caseName) = \"\(key)\"")
        }

        byProperty[prop.name] = FieldCodingKeys(cases: cases, wireKeys: wireKeys)
    }

    return CodingKeysPlan(caseLines: caseLines, byProperty: byProperty)
}

/// The `init(from:)` statement that restores one property, honouring its alias keys.
package func decodeStatement(for prop: StoredProperty, plan: CodingKeysPlan?) -> String {
    let method = prop.isOptional ? "decodeIfPresent" : "decode"
    let keyPlan = plan?.keyPlan(for: prop) ?? .single(prop.name)
    if prop.isMutable, let defaultValue = prop.defaultValue {
        switch keyPlan {
        case .aliases:
            return """
            if let aliasValue = try container.decodeIfPresent(\(prop.typeName).self, \(keyPlan.source)) {
                self.\(prop.name) = aliasValue
            } else {
                self.\(prop.name) = \(defaultValue)
            }
            """
        case .single:
            return """
            if container.contains(.\(prop.name)) {
                self.\(prop.name) = try container.\(method)(\(prop.typeName).self, \(keyPlan.source))
            } else {
                self.\(prop.name) = \(defaultValue)
            }
            """
        }
    }

    return "self.\(prop.name) = try container.\(method)(\(prop.typeName).self, \(keyPlan.source))"
}

// MARK: - MultiConstant
package func multiConstantValues(from attribute: AttributeSyntax) throws -> [String] {
    try flattenedAttributeArguments(from: attribute, label: "MultiConstant")
        .map { $0.trimmedDescription }
}

package func multiConstantValues(from caseDecl: EnumCaseDeclSyntax) throws -> [String]? {
    let attributes = markerAttributes(named: "MultiConstant", in: caseDecl.attributes)

    guard attributes.count <= 1 else {
        throw MacroError("@MultiConstant can only be applied once to each case")
    }

    return try attributes.first.map { try multiConstantValues(from: $0) }
}

// MARK: - Member inspection
package func memberNames(of declaration: some DeclGroupSyntax, in name: String? = nil) -> [String] {
    let signature: (FunctionSignatureSyntax) -> String = {
        guard let first = $0.parameterClause.parameters.first else { return "()" }
        return "(\(first.firstName.text):)"
    }
    let members: MemberBlockItemListSyntax
    if let name {
        guard let nested = declaration.memberBlock.members
            .compactMap({ $0.decl.asProtocol(DeclGroupSyntax.self) })
            .first(where: { $0.asProtocol(NamedDeclSyntax.self)?.name.text == name })
        else { return [] }
        members = nested.memberBlock.members
    } else {
        members = declaration.memberBlock.members
    }
    return members.flatMap { member -> [String] in
        if let caseDecl = member.decl.as(EnumCaseDeclSyntax.self) {
            return caseDecl.elements.map { unquote(fromCaseName: $0.name.text) }
        }
        if let initDecl = member.decl.as(InitializerDeclSyntax.self) {
            return ["init" + signature(initDecl.signature)]
        }
        if let funcDecl = member.decl.as(FunctionDeclSyntax.self) {
            return [funcDecl.name.text + signature(funcDecl.signature)]
        }
        return member.decl.asProtocol(NamedDeclSyntax.self).map { [unquote(fromCaseName: $0.name.text)] } ?? []
    }
}

// MARK: - Macro Error
/// A message-only failure a macro raises while expanding, reported at the offending declaration.
public enum MacroError: Error, CustomStringConvertible {
    case message(String)

    init(_ message: String) { self = .message(message) }

    public var description: String {
        switch self {
        case .message(let msg): return msg
        }
    }
}

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

// MARK: - Shared helpers
package struct StoredProperty {
    let name: String
    let typeName: String
    let isOptional: Bool
    let isTransient: Bool
    let isStatic: Bool
    let isImmutableWithDefault: Bool
    let isMutable: Bool
    let defaultValue: String?
}

package struct TypeOptionality {
    let name: String
    let isOptional: Bool
}

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

package func multiConstantValues(from attribute: AttributeSyntax) throws -> [String] {
    guard case let .argumentList(arguments) = attribute.arguments,
          !arguments.isEmpty
    else { throw MacroError("@MultiConstant requires at least one value") }

    if arguments.count == 1,
       let values = arguments.first?.expression.as(ArrayExprSyntax.self) {
        guard !values.elements.isEmpty else {
            throw MacroError("@MultiConstant requires at least one value")
        }
        return values.elements.map { $0.expression.trimmedDescription }
    }

    return arguments.map { $0.expression.trimmedDescription }
}

package func multiConstantValues(from caseDecl: EnumCaseDeclSyntax) throws -> [String]? {
    let attributes = caseDecl.attributes.compactMap { $0.as(AttributeSyntax.self) }
        .filter { $0.attributeName.trimmedDescription == "MultiConstant" }

    guard attributes.count <= 1 else {
        throw MacroError("@MultiConstant can only be applied once to each case")
    }

    return try attributes.first.map { try multiConstantValues(from: $0) }
}

package func collectStoredProperties(of declaration: some DeclGroupSyntax) -> [StoredProperty] {
    declaration.memberBlock.members.compactMap { member in
        guard let varDecl = member.decl.as(VariableDeclSyntax.self),
                (varDecl.bindingSpecifier.tokenKind == .keyword(.let) || varDecl.bindingSpecifier.tokenKind == .keyword(.var)),
              let binding = varDecl.bindings.first,
              binding.accessorBlock == nil,
              let pattern = binding.pattern.as(IdentifierPatternSyntax.self),
              let typeAnnotation = binding.typeAnnotation
        else { return nil }

        let type = typeAnnotation.type.as(OptionalTypeSyntax.self)
            .map({ TypeOptionality(name: $0.wrappedType.trimmedDescription, isOptional: true) })
            ?? TypeOptionality(name: typeAnnotation.type.trimmedDescription, isOptional: false)
        
        let isTransient = varDecl.attributes.contains { attr in
            attr.as(AttributeSyntax.self)?.attributeName
                .as(IdentifierTypeSyntax.self)?.name.text == "transient"
        }
        
        let isStatic = varDecl.modifiers.contains(where: { $0.name.tokenKind == .keyword(.static) })
        let isImmutableWithDefault = varDecl.bindingSpecifier.tokenKind == .keyword(.let) && binding.initializer != nil
        let isMutable = varDecl.bindingSpecifier.tokenKind == .keyword(.var)
        let defaultValue = binding.initializer?.value.trimmedDescription

        return StoredProperty(
            name: pattern.identifier.text,
            typeName: type.name,
            isOptional: type.isOptional,
            isTransient: isTransient,
            isStatic: isStatic,
            isImmutableWithDefault: isImmutableWithDefault,
            isMutable: isMutable,
            defaultValue: defaultValue
        )
    }
}

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
public enum MacroError: Error, CustomStringConvertible {
    case message(String)

    init(_ message: String) { self = .message(message) }

    public var description: String {
        switch self {
        case .message(let msg): return msg
        }
    }
}

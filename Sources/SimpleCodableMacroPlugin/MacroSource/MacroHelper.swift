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

package func multiConstantValues(from attribute: AttributeSyntax) throws -> [String] {
    guard case let .argumentList(arguments) = attribute.arguments,
          !arguments.isEmpty
    else {
        throw MacroError("@MultiConstant requires at least one value")
    }

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

package func collectStoredProperties(of structDecl: StructDeclSyntax) -> [StoredProperty] {
    structDecl.memberBlock.members.compactMap { member in
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
        
        return StoredProperty(
            name: pattern.identifier.text,
            typeName: type.name,
            isOptional: type.isOptional,
            isTransient: isTransient,
            isStatic: isStatic,
            isImmutableWithDefault: isImmutableWithDefault
        )
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

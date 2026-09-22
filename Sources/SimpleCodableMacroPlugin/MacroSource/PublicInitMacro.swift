import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

struct PublicInitMacro: MemberMacro {
    static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard declaration.is(StructDeclSyntax.self) || declaration.is(ClassDeclSyntax.self) else {
            throw MacroError("@PublicInit can only be applied to structs or classes")
        }

        // Class inheritance requires delegating to a superclass initializer, whose parameter
        // list is not available from the declaration alone. SwiftSyntax also cannot distinguish
        // a superclass from protocol conformances, so only root classes are accepted here.
        if let classDecl = declaration.as(ClassDeclSyntax.self) {
            guard classDecl.inheritanceClause == nil else {
                throw MacroError("@PublicInit does not support classes with an inheritance clause")
            }
        }

        // Skip when the type declares its own init, otherwise overloads become ambiguous.
        guard !declaration.memberBlock.members.contains(where: { $0.decl.is(InitializerDeclSyntax.self) }) else {
            return []
        }

        let stored = collectStoredProperties(of: declaration).filter { !$0.isStatic && !$0.isImmutableWithDefault }
        let initParams = stored.map { prop -> String in
            prop.isOptional ? "\(prop.name): \(prop.typeName)? = nil" : "\(prop.name): \(prop.typeName)"
        }.joined(separator: ",\n")
        let initBody = stored.map { "self.\($0.name) = \($0.name)" }.joined(separator: "\n")

        let initDecl: DeclSyntax = """
            public init(
                \(raw: initParams)
            ) {
                \(raw: initBody)
            }
            """
        return [initDecl]
    }
}

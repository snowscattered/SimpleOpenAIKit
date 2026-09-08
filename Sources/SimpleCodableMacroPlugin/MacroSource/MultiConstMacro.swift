import SwiftSyntax
import SwiftSyntaxMacros

/// A marker macro that supplies the field values used to decode an enum case.
/// Produces no code; `@CodableByConstant` and `@CodableByConstantAndSingle`
/// read the annotation while generating their decoding branches.
struct MultiConstMacro: PeerMacro {
    static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard declaration.is(EnumCaseDeclSyntax.self) else {
            throw MacroError("@MultiConstant can only be applied to enum cases")
        }

        _ = try multiConstantValues(from: node)
        return []
    }
}

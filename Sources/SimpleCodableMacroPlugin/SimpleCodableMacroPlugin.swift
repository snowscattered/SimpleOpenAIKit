import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct SimpleCodableMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        CodableLiteralMacro.self,
        CodableTraversalMacro.self,
        TransientMacro.self,
        SingleOrArrayMacro.self,
        CodableByConstantMacro.self,
        CodableByConstantAndSingleMacro.self,
        MultiConstMacro.self,
        BaseModelWithExtraMacro.self,
        BaseModelNoWithExtraMacro.self,
    ]
}

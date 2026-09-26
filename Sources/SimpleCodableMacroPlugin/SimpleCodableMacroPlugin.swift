import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct SimpleCodableMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        // struct
        BaseModelWithExtraMacro.self,
        BaseModelNoWithExtraMacro.self,
        PublicInitMacro.self,
        // enum
        MultiConstMacro.self,
        TransientMacro.self,
        CodableLiteralMacro.self,
        CodableStringLiteralWithOtherMacro.self,
        CodableTraversalMacro.self,
        
        CodableByConstantMacro.self,
        CodableByConstantAndSingleMacro.self,
        
        SingleOrArrayMacro.self,
    ]
}

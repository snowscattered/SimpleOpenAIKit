import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Compiler plugin that publishes the Codable helpers re-exported by `SimpleCodableMacro`.
@main
struct SimpleCodableMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        // struct
        BaseModelFieldAliasMacro.self,
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

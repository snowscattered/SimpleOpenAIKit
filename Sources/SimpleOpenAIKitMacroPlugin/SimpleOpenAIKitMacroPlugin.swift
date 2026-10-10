//
//  SimpleOpenAIMacroPlugin.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/6/26.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
@_exported import SimpleCodableMacro

/// Compiler plugin that publishes the tool-schema macros re-exported by `SimpleOpenAIKitMacro`.
@main
struct SimpleOpenAIMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ArgumentDescriptionMacro.self,
        StringToolArgumentMacro.self,
        NumberToolArgumentMacro.self,
        BooleanToolArgumentMacro.self,
        ArrayToolArgumentMacro.self,
        ReferToolArgumentMacro.self,
        EnumToolArgumentMacro.self,
        AnyOfToolArgumentMacro.self,
        MainArgumentMacro.self,
        ReferArgumentMacro.self,
    ]
}

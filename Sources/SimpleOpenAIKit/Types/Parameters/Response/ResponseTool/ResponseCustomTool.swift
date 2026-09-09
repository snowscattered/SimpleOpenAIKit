//
//  ResponseCustomTool.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@CodableLiteral
public enum ResponseGrammarSyntaxLiteral: String {
    case lark, regex
}

@BaseModelNoWithExtra
public struct ResponseCustomFormatText {
    public static let type: String = "text"
}

@BaseModelNoWithExtra
public struct ResponseCustomFormatGrammar {
    public static let type: String = "grammar"
    public var definition: String
    public var syntax: ResponseGrammarSyntaxLiteral
}

@CodableByConstant
public enum ResponseCustomToolInputFormat {
    case text(ResponseCustomFormatText)
    case grammar(ResponseCustomFormatGrammar)
}

@BaseModelNoWithExtra
public struct ResponseCustomTool {
    public static let type: String = "custom"
    public var name: String
    public var defer_loading: Bool?
    public var description: String?
    public var format: ResponseCustomToolInputFormat?
    public var async: Bool?
    public var allowed_callers: [ResponseToolAllowedCallers]?
}

//
//  ResponseTool.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

// Share
@CodableLiteral
public enum ResponseToolAllowedCallers: String {
    case direct, programmatic
}

@BaseModelWithExtra
public struct ResponseBaseTool {
    public var type: String
}

@CodableByConstant(defaultCase: "other")
@nonexhaustive
public enum ResponseTool {
    case function(ResponseFunctionTool)
    case custom(ResponseCustomTool)
    case namespace(ResponseNamespaceTool)
    case file_search(ResponseFileSearchTool)
    case image_generation(ResponseImageGenerationTool)
    case web_search(ResponseWebSearchTool)
    // case computer()
    // case code_interpreter()
    // case local_shell()
    // case mcp()
    // case apply_patch()
    // case tool_search()
    // Extension OpenAI
    case other(ResponseBaseTool)
}

// Add Simple Use
extension ResponseTool {
    public static var image_generation: ResponseTool {
        return .image_generation(.init())
    }
    public static var web_search: ResponseTool {
        return .web_search(.init())
    }
}

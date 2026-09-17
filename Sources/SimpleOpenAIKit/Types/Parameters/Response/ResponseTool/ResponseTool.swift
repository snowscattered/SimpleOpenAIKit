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

@CodableByConstant(defaultCase: "unowned")
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
    case unowned(ResponseBaseTool)
}

public extension ResponseTool {
    var type: String {
        switch self {
        case .function:           return ResponseFunctionTool.type
        case .custom:             return ResponseCustomTool.type
        case .namespace:          return ResponseNamespaceTool.type
        case .file_search:        return ResponseFileSearchTool.type
        case .image_generation:   return ResponseImageGenerationTool.type
        case .web_search:         return ResponseWebSearchTool.type
        case .unowned(let event): return event.type
        }
    }
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

//
//  ResponseInputItem.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelWithExtra
public struct ResponseBaseItem {
    public var type: String
}
@CodableByConstant(nilCase: "message", still: true, defaultCase: "unkowned")
@nonexhaustive
public enum ResponseInputItem {
    case message(ResponseMessageItem)
    case reasoning(ResponseReasoningItem)
    
    case function_call(ResponseFunctionCallItem)
    case function_call_output(ResponseFunctionCallOutputItem)
    case custom_tool_call(ResponseCustomToolCallItem)
    case custom_tool_call_output(ResponseCustomToolCallOutputItem)
    case web_search(ResponseWebSearchItem)
    // Codex Agent Message
    case agent_message(ResponseAgentMessageItem)
    
    case unkowned(ResponseBaseItem)
}

extension ResponseInputItem {
    public static func developer(_ content: ResponseMessageInputItemContent) -> Self {
        return .message(.EasyInputMessage(.init(role: .developer, content: content)))
    }
    public static func system(_ content: ResponseMessageInputItemContent) -> Self {
        return .message(.EasyInputMessage(.init(role: .system, content: content)))
    }
    public static func user(_ content: ResponseMessageInputItemContent) -> Self {
        return .message(.EasyInputMessage(.init(role: .user, content: content)))
    }
    public static func assistant(_ content: ResponseMessageInputItemContent) -> Self {
        return .message(.EasyInputMessage(.init(role: .assistant, content: content)))
    }
}

public extension ResponseInputItem {
    var type: String {
        switch self {
        case .message:                 return ResponseMessageItem.type
        case .reasoning:               return ResponseReasoningItem.type
        case .function_call:           return ResponseFunctionCallItem.type
        case .function_call_output:    return ResponseFunctionCallOutputItem.type
        case .custom_tool_call:        return ResponseCustomToolCallItem.type
        case .custom_tool_call_output: return ResponseCustomToolCallOutputItem.type
        case .web_search:              return ResponseWebSearchItem.type
        // Codex Agent Message
        case .agent_message:           return ResponseAgentMessageItem.type
        case .unkowned(let event):     return event.type
        }
    }
}

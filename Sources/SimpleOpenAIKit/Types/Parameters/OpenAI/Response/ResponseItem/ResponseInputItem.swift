//
//  ResponseInputItem.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelWithExtra
@PublicInit
public struct ResponseBaseItem {
    public var type: String
}
@CodableByConstant(nilCase: "message", still: true, defaultCase: "unkowned")
@nonexhaustive
public enum ResponseInputItem {
    case message(ResponseMessageItem)
    case reasoning(ResponseReasoningItem)
    
    case function_call(ResponseFunctionToolCallItem)
    case function_call_output(ResponseFunctionToolCallOutputItem)
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

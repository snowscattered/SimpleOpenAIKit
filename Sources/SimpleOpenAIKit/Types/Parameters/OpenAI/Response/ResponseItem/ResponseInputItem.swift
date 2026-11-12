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

public extension ResponseInputItem {
    static func developer(_ content: ResponseMessageInputItemContent) -> Self {
        return .message(.EasyInputMessage(.init(role: .developer, content: content)))
    }
    static func system(_ content: ResponseMessageInputItemContent) -> Self {
        return .message(.EasyInputMessage(.init(role: .system, content: content)))
    }
    static func user(_ content: ResponseMessageInputItemContent) -> Self {
        return .message(.EasyInputMessage(.init(role: .user, content: content)))
    }
    static func assistant(_ content: ResponseMessageInputItemContent) -> Self {
        return .message(.EasyInputMessage(.init(role: .assistant, content: content)))
    }
}

public extension ResponseInputItem {
    static func developer(_ text: String) -> Self {
        .developer(.string(text))
    }
    static func developer(_ content: [ResponseContent]) -> Self {
        .developer(.array(content))
    }
    static func system(_ text: String) -> Self {
        .system(.string(text))
    }
    static func system(_ content: [ResponseContent]) -> Self {
        .system(.array(content))
    }
    static func user(_ text: String) -> Self {
        .user(.string(text))
    }
    static func user(_ content: [ResponseContent]) -> Self {
        .user(.array(content))
    }
    static func assistant(_ text: String) -> Self {
        .assistant(.string(text))
    }
    static func assistant(_ content: [ResponseContent]) -> Self {
        .assistant(.array(content))
    }
}

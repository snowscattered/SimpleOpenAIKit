//
//  ChatAssistantMessageTypes.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ChatAssistantAudio {
    public var id: String
    /// Result Field
    public let data: String?
    public let expires_at: String?
    public let transcript: String?
}

@CodableByConstant
public enum ChatContentAssistentPart {
    case text(ChatContentPartText)
    case refusal(ChatContentPartRefusal)
}
@SingleOrArray
public enum ChatStringOrContentAssistentPart {
    case string(String)
    case array([ChatContentAssistentPart])
}
extension ChatStringOrContentAssistentPart: ExpressibleByStringLiteral, ExpressibleByArrayLiteral {
    public init(stringLiteral value: String)                        { self = .string(value) }
    public init(arrayLiteral elements: ChatContentAssistentPart...) { self = .array(elements) }
}

@BaseModelWithExtra
public struct ChatAssistantFunctionCall {
    public var name: String
    public var arguments: String
}

@BaseModelNoWithExtra
public struct ChatAssistantFunction {
    public var name: String
    public var arguments: String
}

@BaseModelNoWithExtra
public struct ChatFunctionToolCall {
    public static let type: String = "function"
    public var id: String
    public var function: ChatAssistantFunction
}

@BaseModelNoWithExtra
public struct ChatAssistantCustom {
    public var input: String
    public var name: String
}

@BaseModelNoWithExtra
public struct ChatCustomToolCall {
    public static let type: String = "custom"
    public var id: String
    public var custom: ChatAssistantCustom
}

@CodableByConstant
public enum ChatToolCall {
    case function(ChatFunctionToolCall)
    case custom(ChatCustomToolCall)
}

@BaseModelNoWithExtra
public struct ChatAnnotationURLCitation {
    public var end_index: Int
    public var start_index: Int
    public var title: String
    public var url: String
}
@BaseModelNoWithExtra
public struct ChatAnnotation {
    public static let type: String = "url_citation"
    public var url_citation: ChatAnnotationURLCitation
}

@BaseModelNoWithExtra
public struct ChatAssistantMessage {
    public static let role: String = "assistant"
    public var audio: ChatAssistantAudio?
    public var content: ChatStringOrContentAssistentPart?
    public var function_call: ChatAssistantFunctionCall?
    public var refusal: String?
    public var tool_calls: [ChatToolCall]?
    public var name: String?
    public var reasoning_content: String?
    /// Result Field
    let annotation: [ChatAnnotation]?
}
extension ChatAssistantMessage: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) { self = .init(content: .string(value)) }
}

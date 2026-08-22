//
//  ChatStreamResult.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/8/26.
//

import Foundation
import SimpleCodableMacro

// Choice
@CodableLiteral
public enum ChatStreamChoiceRole: String {
    case developer
    case system
    case user
    case assistant
    case tool
}
@BaseModelNoWithExtra
public struct ChatFunctionCallDelta {
    public let arguments: String?
    public let name: String?
}
@BaseModelNoWithExtra
public struct ChatToolCallFunctionDelta {
    public let arguments: String?
    public let name: String?
}
@BaseModelNoWithExtra
public struct ChatToolCallDelta {
    public let index: Int
    public let id: String?
    public let function: ChatFunctionCallDelta?
    public var type: String? = "function"
}
@BaseModelNoWithExtra
public struct ChatDelta{
    public let content: String?
    public let function_call: ChatToolCallFunctionDelta?
    public let refusal: String?
    public let role: ChatStreamChoiceRole?
    public let tool_calls: [ChatToolCallDelta]?
    /// Extension OpenAI API
    public let reasoning_content: String?
}
@BaseModelNoWithExtra
public struct ChatStreamChoice{
    public let delta: ChatDelta
    public let finish_reason: ChatChoiceFinshReasonLiteral?
    public let index: Int
    public let logprobs: ChatLogprobs?
}

// StreamResult
@BaseModelNoWithExtra
public struct ChatStreamResult {
    public let id: String
    public let choices: [ChatStreamChoice]
    public let created: Int
    public let model: String
    public static let object: String = "chat.completion"
    public let service_tier: ChatServiceTier?
    public let system_fingerprint: String?
    public let usage: ChatUsage?
}

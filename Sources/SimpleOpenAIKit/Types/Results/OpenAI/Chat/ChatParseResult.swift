//
//  ChatParseResult.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/10/6.
//

import Foundation
import SimpleCodableMacro

public struct ChatParseFunction {
    public let name: String
    public let arguments: String
    public let parsed_arguments: [String: BaseType]?
}

public struct ChatParseFunctionToolCall {
    public static let type: String = "function"
    public let id: String
    public let function: ChatParseFunction
}

public struct ChatParseMessage<T> {
    public static var role: String { "assistant" }
    public let audio: ChatAssistantAudio?
    public let content: ChatStringOrContentAssistentPart?
    public let function_call: ChatAssistantFunctionCall?
    public let refusal: String?
    public let tool_calls: [ChatParseFunctionToolCall]?
    public let name: String?
    public let reasoning_content: String?
    /// Result Field
    public let annotation: [ChatAnnotation]?
    public let parsed: T?
}


public struct ChatParseChoice<T> {
    public let index: Int
    public let message: ChatParseMessage<T>
    public let finish_reason: ChatChoiceFinshReasonLiteral
    public let logprobs: ChatLogprobs?
}

public struct ChatParseResult<T> {
    public static var object: String { "chat.completion" }
    public let id: String
    public let choices: [ChatParseChoice<T>]
    public let created: Int
    public let model: String
    public let service_tier: ChatServiceTier?
    public let system_fingerprint: String?
    public let usage: ChatUsage?
}
// MARK: - To ChatCreateResult
extension ChatParseFunction {
    var chatFunction: ChatAssistantFunction {
        .init(name: self.name, arguments: self.arguments)
    }
}
extension ChatParseFunctionToolCall {
    var chatAssistantFunctionCall: ChatToolCall {
        .function(.init(id: self.id, function: self.function.chatFunction))
    }
}
extension ChatParseMessage {
    var chatAssistantMessage: ChatAssistantMessage {
        .init(
            audio: self.audio,
            content: self.content,
            function_call: self.function_call,
            refusal: self.refusal,
            tool_calls: self.tool_calls?.map { $0.chatAssistantFunctionCall },
            name: self.name,
            reasoning_content: self.reasoning_content,
            annotation: self.annotation
        )
    }
}
public extension Array where Element == ChatMessage {
    static func + <T>(lhs: [ChatMessage], rhs: ChatParseMessage<T>) -> [ChatMessage] {
        lhs + [.assistant(rhs.chatAssistantMessage)]
    }
}

// MARK: - From ChatCreateResult
extension ChatParseFunctionToolCall {
    init(_ tool_call: ChatFunctionToolCall) throws {
        self.init(id: tool_call.id, function: try ChatParseFunction(tool_call.function))
    }
}
extension ChatParseFunction {
    init(_ function: ChatAssistantFunction) throws {
        let data = Data(function.arguments.utf8)
        self.init(
            name: function.name,
            arguments: function.arguments,
            parsed_arguments: data.isEmpty ? nil : try JSONDecoder().decode([String: BaseType].self, from: data)
        )
    }
}
extension ChatParseMessage where T: Decodable {
    init(_ message: ChatAssistantMessage) throws {
        var parsed: T? = nil
        if case .string(let content)? = message.content {
            parsed = try JSONDecoder().decode(T.self, from: Data(content.utf8))
        }
        var tool_calls: [ChatParseFunctionToolCall]? = nil
        if let calls = message.tool_calls {
            tool_calls = try calls.compactMap { call in
                guard case .function(let function_call) = call else { return nil }
                return try ChatParseFunctionToolCall(function_call)
            }
        }
        self.init(
            audio: message.audio,
            content: message.content,
            function_call: message.function_call,
            refusal: message.refusal,
            tool_calls: tool_calls,
            name: message.name,
            reasoning_content: message.reasoning_content,
            annotation: message.annotation,
            parsed: parsed
        )
    }
}
extension ChatParseChoice where T: Decodable {
    init(_ choice: ChatCreateChoice) throws {
        self.init(
            index: choice.index,
            message: try ChatParseMessage(choice.message),
            finish_reason: choice.finish_reason,
            logprobs: choice.logprobs
        )
    }
}
extension ChatParseResult where T: Decodable {
    init(_ result: ChatCreateResult) throws {
        self.init(
            id: result.id,
            choices: try result.choices.map { try ChatParseChoice($0) },
            created: result.created,
            model: result.model,
            service_tier: result.service_tier,
            system_fingerprint: result.system_fingerprint,
            usage: result.usage
        )
    }
}

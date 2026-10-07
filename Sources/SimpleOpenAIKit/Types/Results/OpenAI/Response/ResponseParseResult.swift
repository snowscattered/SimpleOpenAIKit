//
//  ResponseParseResult.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/10/7.
//

import Foundation

public struct ResponseParseOutputMessage<T> {
    public static var type: String { "message" }
    public static var role: String { "assistant" }
    public let id: String
    public let content: [ResponseOutputMessageContent]
    public let status: ResponseItemStatusLiteral?
    public let phase: ResponsePhaseLiteral?
    /// Result Field
    public let parsed: T?
}

public enum ResponseParseOutputItem<T> {
    case message(ResponseParseOutputMessage<T>)
    case reasoning(ResponseReasoningItem)
    case function_call(ResponseFunctionCallItem)
    case function_call_output(ResponseFunctionCallOutputItem)
    case custom_tool_call(ResponseCustomToolCallItem)
    case custom_tool_call_output(ResponseCustomToolCallOutputItem)
    case web_search(ResponseWebSearchItem)
    case unkowned(ResponseBaseItem)
}

extension ResponseParseOutputItem {
    public func toInputItem() -> ResponseInputItem {
        switch self {
        case .message(let item):                 return .message(.OutputMessage(item.outputMessage))
        case .reasoning(let item):               return .reasoning(item)
        case .function_call(let item):           return .function_call(item)
        case .function_call_output(let item):    return .function_call_output(item)
        case .custom_tool_call(let item):        return .custom_tool_call(item)
        case .custom_tool_call_output(let item): return .custom_tool_call_output(item)
        case .web_search(let item):              return .web_search(item)
        case .unkowned(let item):                return .unkowned(item)
        }
    }
}

public struct ResponseParseResult<T> {
    public static var object: String { "response" }
    public let id: String
    public let created_at: Float
    public let error: ResponseError?
    public let incomplete_details: ResponseIncompleteDetails?
    public let instructions: String?
    public let metadata: OpenAIMetaData?
    public let model: String
    public let output: [ResponseParseOutputItem<T>]
    public let parallel_tool_calls: Bool
    public let temperature: Float?
    public let tool_choice: ResponseToolChoice
    public let tools: [ResponseTool]
    public let top_p: Float?
    public let background: Bool?
    public let completed_at: Float?
    public let conversation: ResponseResultConversation?
    public let max_output_tokens: Int?
    public let max_tool_calls: Int?
    public let previous_response_id: String?
    public let prompt: ResponsePrompt?
    public let prompt_cache_key: String?
    public let prompt_cache_retention: ResponsePromptCacheRetentionLiteral?
    public let reasoning: ResponseReasoning?
    public let safety_identifier: String?
    public let service_tier: ResponseServiceTierLiteral?
    public let status: ResponseStatus?
    public let text: ResponseTextConfig?
    public let top_logprobs: Int?
    public let truncation: ResponseTruncationLiteral?
    public let usage: ResponseUsage?
    public let user: String?
}

public extension ResponseParseResult {
    var output_text: String {
        var texts: [String] = []
        for output in self.output {
            if case .message(let message) = output {
                for content in message.content {
                    if case .output_text(let text) = content {
                        texts.append(text.text)
                    }
                }
            }
        }
        return texts.joined(separator: "")
    }
}

extension ResponseParseOutputMessage {
    var outputMessage: ResponseOutputMessage {
        .init(
            id: self.id,
            content: self.content,
            status: self.status,
            phase: self.phase
        )
    }
}

// MARK: - From ResponseCreateResult
extension ResponseParseOutputMessage where T: Decodable {
    init(_ message: ResponseOutputMessage) throws {
        let text = message.content.compactMap { content in
            if case .output_text(let outputText) = content {
                return outputText.text
            }
            return nil
        }.joined()
        let parsed = text.isEmpty ? nil : try JSONDecoder().decode(T.self, from: Data(text.utf8))

        self.init(
            id: message.id,
            content: message.content,
            status: message.status,
            phase: message.phase,
            parsed: parsed
        )
    }
}

extension ResponseParseOutputItem where T: Decodable {
    init(_ item: ResponseOutputItem) throws {
        switch item {
        case .message(let message):
            self = .message(try ResponseParseOutputMessage(message))
        case .reasoning(let reasoning):
            self = .reasoning(reasoning)
        case .function_call(let functionCall):
            self = .function_call(functionCall)
        case .function_call_output(let functionCallOutput):
            self = .function_call_output(functionCallOutput)
        case .custom_tool_call(let customToolCall):
            self = .custom_tool_call(customToolCall)
        case .custom_tool_call_output(let customToolCallOutput):
            self = .custom_tool_call_output(customToolCallOutput)
        case .web_search(let webSearch):
            self = .web_search(webSearch)
        case .unkowned(let item):
            self = .unkowned(item)
        }
    }
}

extension ResponseParseResult where T: Decodable {
    init(_ result: ResponseCreateResult) throws {
        self.init(
            id: result.id,
            created_at: result.created_at,
            error: result.error,
            incomplete_details: result.incomplete_details,
            instructions: result.instructions,
            metadata: result.metadata,
            model: result.model,
            output: try result.output.map { try ResponseParseOutputItem($0) },
            parallel_tool_calls: result.parallel_tool_calls,
            temperature: result.temperature,
            tool_choice: result.tool_choice,
            tools: result.tools,
            top_p: result.top_p,
            background: result.background,
            completed_at: result.completed_at,
            conversation: result.conversation,
            max_output_tokens: result.max_output_tokens,
            max_tool_calls: result.max_tool_calls,
            previous_response_id: result.previous_response_id,
            prompt: result.prompt,
            prompt_cache_key: result.prompt_cache_key,
            prompt_cache_retention: result.prompt_cache_retention,
            reasoning: result.reasoning,
            safety_identifier: result.safety_identifier,
            service_tier: result.service_tier,
            status: result.status,
            text: result.text,
            top_logprobs: result.top_logprobs,
            truncation: result.truncation,
            usage: result.usage,
            user: result.user
        )
    }
}

public extension Array where Element == ResponseInputItem {
    static func += <T>(lhs: inout [ResponseInputItem], rhs: [ResponseParseOutputItem<T>]) {
        lhs.append(contentsOf: rhs.map { $0.toInputItem() })
    }
}

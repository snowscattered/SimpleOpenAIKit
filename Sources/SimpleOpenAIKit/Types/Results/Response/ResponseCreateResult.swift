//
//  ResponseCreateResult.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

// ResponseCreateResult.IncompleteDetails
@CodableLiteral
public enum ResponseIncompleteReason: String {
    case max_output_tokens
    case content_filter
}
@BaseModelNoWithExtra
public struct ResponseIncompleteDetails {
    public let reason: ResponseIncompleteReason?
}

// ResponseCreateResult.Error
@CodableLiteral
public enum ResponseErrorCode: String {
    case server_error
    case rate_limit_exceeded
    case invalid_prompt
    case vector_store_timeout
    case invalid_image
    case invalid_image_format
    case invalid_base64_image
    case invalid_image_url
    case image_too_large
    case image_too_small
    case image_parse_error
    case image_content_policy_violation
    case invalid_image_mode
    case image_file_too_large
    case unsupported_image_media_type
    case empty_image_file
    case failed_to_download_image
    case image_file_not_found
}
@BaseModelNoWithExtra
public struct ResponseError {
    public let code: ResponseErrorCode
    public let message: String
}

// ResponseCreateResult.Conversation
@BaseModelNoWithExtra
public struct ResponseResultConversation {
    public let id: String
}
// ResponseCreateResult.Status
@CodableLiteral
public enum ResponseStatus: String {
    case completed
    case failed
    case in_progress
    case cancelled
    case queued
    case incomplete
}
// ResponseCreateResult.Usage
@BaseModelNoWithExtra
public struct ResponseInputTokensDetails {
    public let cached_tokens: Int
}
@BaseModelNoWithExtra
public struct ResponseOutputTokensDetails {
    public let reasoning_tokens: Int
}
@BaseModelNoWithExtra
public struct ResponseUsage {
    public let input_tokens: Int
    public let output_tokens: Int
    public let total_tokens: Int
    public let input_tokens_details: ResponseInputTokensDetails
    public let output_tokens_details: ResponseOutputTokensDetails
}

//public typealias ResponseOutputItem = ResponseInputItem
@CodableByConstant(defaultCase: "other")
@nonexhaustive
public enum ResponseOutputItem {
    case message(ResponseOutputMessage)  // Not Bind with ResponseInputItem
    
    case reasoning(ResponseReasoningItem)
    case function_call(ResponseFunctionCallItem)
    case function_call_output(ResponseFunctionCallOutputItem)
    case custom_tool_call(ResponseCustomToolCallItem)
    case custom_tool_call_output(ResponseCustomToolCallOutputItem)
    case web_search(ResponseWebSearchItem)
    
    case other(ResponseBaseItem)
}
extension ResponseOutputItem {
    public func toInputItem() -> ResponseInputItem {
        switch self {
        case .message(let item):                 return .message(.OutputMessage(item))
        case .reasoning(let item):               return .reasoning(item)
        
        case .function_call(let item):           return .function_call(item)
        case .function_call_output(let item):    return .function_call_output(item)
        case .custom_tool_call(let item):        return .custom_tool_call(item)
        case .custom_tool_call_output(let item): return .custom_tool_call_output(item)
        case .web_search(let item):              return .web_search(item)
            
        case .other(let item):                   return .other(item)
        }
    }
}

@BaseModelNoWithExtra
public struct ResponseCreateResult {
    public static let object: String = "response"
    public let id: String
    public let created_at: Float
    public let error: ResponseError?
    public let incomplete_details: ResponseIncompleteDetails?
    public let instructions: String?
    public let metadata: OpenAIMetaData?
    public let model: String
    public let output: [ResponseOutputItem]
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
extension ResponseCreateResult {
    public var output_text: String {
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
extension Array where Element == ResponseInputItem {
    public static func +=(lhs: inout [ResponseInputItem], rhs: [ResponseOutputItem]) {
        lhs.append(contentsOf: rhs.map { $0.toInputItem() })
    }
}

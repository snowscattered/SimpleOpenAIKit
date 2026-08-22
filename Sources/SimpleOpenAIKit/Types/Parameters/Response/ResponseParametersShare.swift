//
//  ResponseSupport.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/25/26.
//

import Foundation
import SimpleCodableMacro

// MARK: - Item
@SingleOrArray
public enum ResponseInputOrItems {
    case string(String)
    case array([ResponseInputItem])
}
extension ResponseInputOrItems: ExpressibleByStringLiteral, ExpressibleByArrayLiteral {
    public init(stringLiteral value: String)                 { self = .string(value) }
    public init(arrayLiteral elements: ResponseInputItem...) { self = .array(elements) }
}
@CodableLiteral
public enum ResponseItemStatusLiteral: String {
    case in_progress, completed, incomplete
}

// MARK: - Conversation
@BaseModelNoWithExtra
public struct ResponseConversationStruct {
    public var id: String
}

@CodableTraversal
public enum ResponseConversation {
    case string(String)
    case object(ResponseConversationStruct)
}

// MARK: - ResponseToolChoice
@CodableLiteral
public enum ResponseToolChoiceOptions: String {
    case none, auto, required
}
@CodableLiteral
public enum ResponseToolChoiceAllowedModel: String {
    case auto, required
}
@BaseModelNoWithExtra
public struct ResponseToolChoiceAllowed {
    public static let type: String = "allowed_tools"
    public var mode: ResponseToolChoiceAllowedModel
    public var tools: [[String: BaseType]]
}
@CodableLiteral
public enum ResponseToolChoiceTypesType: String {
    case file_search
    case web_search_preview
    case computer_use_preview
    case image_generation
    case code_interpreter
}
@BaseModelNoWithExtra
public struct ResponseToolChoiceTypes {
    public var type: ResponseToolChoiceTypesType
}
@BaseModelNoWithExtra
public struct ResponseToolChoiceFunction {
    public static let type: String = "function"
    public let name: String
}
@BaseModelNoWithExtra
public struct ResponseToolChoiceMcp {
    public static let type: String = "mcp"
    public let server_label: String
    public let name: String
}
@BaseModelNoWithExtra
public struct ResponseToolChoiceCustom {
    public static let type: String = "custom"
    public var name: String
}
@BaseModelNoWithExtra
public struct ResponseToolChoiceApplyPatch {
    public static let type: String = "apply_patch"
}
@BaseModelNoWithExtra
public struct ResponseToolChoiceShell {
    public static let type: String = "shell"
}

@CodableByConstantAndSingle(singleCase: "option", defaultCase: "types")
public enum ResponseToolChoice {
    case option(ResponseToolChoiceOptions)
    case types(ResponseToolChoiceTypes)
    case function(ResponseToolChoiceFunction)
    case mcp(ResponseToolChoiceMcp)
    case custom(ResponseToolChoiceCustom)
    case apply_patch(ResponseToolChoiceApplyPatch)
    case shell(ResponseToolChoiceShell)
}

public typealias ResponseReasoningEffortLiteral = OpenAIReasoningEffortLiteral

@CodableLiteral
public enum ResponseReasoningSummaryLiteral: String {
    case auto, concise, detailed
}

@BaseModelNoWithExtra
public struct ResponseReasoning {
    public var effort: ResponseReasoningEffortLiteral? = ResponseReasoningEffortLiteral.none
    public var generate_summary: ResponseReasoningSummaryLiteral?
    public var summary: ResponseReasoningSummaryLiteral?
}

// MARK: - Include
@CodableLiteral
public enum ResponseIncludeLiteral: String {
    case file_search_call_results = "file_search_call.results"
    case web_search_call_results = "web_search_call.results"
    case web_search_call_action_sources = "web_search_call.action.sources"
    case message_input_image_image_url = "message.input_image.image_url"
    case computer_call_output_output_image_url = "computer_call_output.output.image_url"
    case code_interpreter_call_outputs = "code_interpreter_call.outputs"
    case reasoning_encrypted_content = "reasoning.encrypted_content"
    case message_output_text_logprobs = "message.output_text.logprobs"
}

// MARK: - Context Management

@BaseModelNoWithExtra
public struct ResponseContextManagement {
    public var type: String
    public var compact_threshold: Int?
}

// MARK: - Stream Options

@BaseModelNoWithExtra
public struct ResponseStreamOptions {
    public var include_obfuscation: Bool?
    public var include_usage: Bool?
}

// MARK: - Response Format & Text Config

@BaseModelNoWithExtra
public struct ResponseFormatText {
    public static let type: String = "text"
}

@BaseModelNoWithExtra
public struct ResponseFormatJSONSchema {
    public static let type: String = "json_schema"
    public var name: String
    public var schema: [String: BaseType]
    public var description: String?
    public var strict: Bool?
}

@BaseModelNoWithExtra
public struct ResponseFormatJSONObject {
    public static let type: String = "json_object"
}


@CodableByConstant
public enum ResponseFormatTextConfig {
    case text(ResponseFormatText)
    case json_schema(ResponseFormatJSONSchema)
    case json_object(ResponseFormatJSONObject)
}

@CodableLiteral
public enum ResponseVerbosityLiteral: String {
    case low, medium, high
}

@BaseModelNoWithExtra
public struct ResponseTextConfig {
    public var format: ResponseFormatTextConfig?
    public var verbosity: ResponseVerbosityLiteral?
}

// MARK: - Moderation
@CodableLiteral
public enum ResponseModerationMode: String {
    case score
    case block
}

@BaseModelNoWithExtra
public struct ResponseModerationPolicyInput {
    public var mode: ResponseModerationMode
}

@BaseModelNoWithExtra
public struct ResponseModerationPolicyOutput {
    public var mode: ResponseModerationMode
}

@BaseModelNoWithExtra
public struct ResponseModerationPolicy {
    public var input: ResponseModerationPolicyInput?
    public var output: ResponseModerationPolicyOutput?
}

@BaseModelNoWithExtra
public struct ResponseModeration {
    public var model: String
    public var policy: ResponseModerationPolicy?
}

// MARK: - Prompt

@CodableByConstant
public enum ResponsePromptVariable {
    case input_text(ResponseTextContent)
    case input_image(ResponseImageContent)
    case input_file(ResponseFileContent)
}

@BaseModelNoWithExtra
public struct ResponsePrompt {
    public var id: String
    public var variables: [String: ResponsePromptVariable]?
    public var version: String?
}

// MARK: - Prompt Cache
@CodableLiteral
public enum ResponsePromptCacheMode: String {
    case implicit
    case explicit
}

@CodableLiteral
public enum ResponsePromptCacheTTL: String {
    case _30m = "30m"
}

@BaseModelNoWithExtra
public struct ResponsePromptCacheOption {
    public var mode: ResponsePromptCacheMode?
    public var ttl: ResponsePromptCacheTTL?
}

@CodableLiteral
public enum ResponsePromptCacheRetentionLiteral: String {
    case inMemory = "in-memory"
    case h24 = "24h"
}

// MARK: - Servive Tier
@CodableLiteral
public enum ResponseServiceTierLiteral: String {
    case auto, `default`, flex, scale, priority
}

// MARK: - Truncation
@CodableLiteral
public enum ResponseTruncationLiteral: String {
    case auto, disabled
}

public typealias ResponseMetaData = OpenAIMetaData

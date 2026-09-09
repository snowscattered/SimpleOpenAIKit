//
//  ChatParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

// MARK: - Stream Options

@BaseModelNoWithExtra
public struct ChatStreamOptions {
    public var include_obfuscation: Bool?
    public var include_usage: Bool?
}

// MARK: - Audio

@CodableLiteral
public enum ChatAudioFormatLiteral: String {
    case wav, aac, mp3, flac, opus, pcm16
}

@BaseModelNoWithExtra
public struct ChatAudio {
    public var voice: String
    public var format: ChatAudioFormatLiteral
}

// MARK: - FuncionCall
@BaseModelNoWithExtra
public struct ChatFunctionCallOption {
    public var name: String
}
@CodableLiteral
public enum ChatFunctionCallLiteral: String {
    case auto, none
}
@CodableTraversal
public enum ChatFunctionCall {
    case literal(ChatFunctionCallLiteral)
    case option(ChatFunctionCallOption)
}

// MARK: - Tool
/// MARK: FunctionTool
@BaseModelNoWithExtra
public struct ChatFunction {
    public var name: String
    public var description: String?
    public var parameters: [String: BaseType]?
    public var strict: Bool?
}
@BaseModelNoWithExtra
public struct ChatFunctionTool {
    public static let type: String = "function"
    public var function: ChatFunction
}
/// MARK: CustomTool
@BaseModelNoWithExtra
public struct ChatCustomTextFormat {
    public static let type: String = "text"
}
@CodableLiteral
public enum ChatCustomGrammarFormatSyntax: String {
    case lark
    case regex
}
@BaseModelNoWithExtra
public struct ChatCustomGrammarFormatGrammar {
    public var definition: String
    public var syntax: ChatCustomGrammarFormatSyntax
}
@BaseModelNoWithExtra
public struct ChatCustomGrammarFormat {
    public static let type: String = "grammar"
    public var grammar: ChatCustomGrammarFormatGrammar
}
@CodableByConstant
public enum ChatCustomFormat {
    case text(ChatCustomTextFormat)
    case grammar(ChatCustomGrammarFormat)
}
@BaseModelNoWithExtra
public struct ChatCustom {
    public var name: String
    public var description: String?
    public var format: ChatCustomFormat
}
@BaseModelNoWithExtra
public struct ChatCustomTool {
    public static let type: String = "custom"
    public var custom: ChatCustom
}
@CodableByConstant
public enum ChatTool {
    case function_tool(ChatFunctionTool)
    case custom_tool(ChatCustomTool)
}

// MARK: - Tool Choice

@CodableLiteral
public enum ChatToolChoiceLiteral: String {
    case none, auto, required
}
@CodableLiteral
public enum ChatAllowedToolsModeLiteral: String {
    case all, required
}
@BaseModelNoWithExtra
public struct ChatAllowedTools {
    public var mode: ChatAllowedToolsModeLiteral
    public var tools: [String: BaseType]
}
@BaseModelNoWithExtra
public struct ChatAllowedToolChoiceType {
    public static let type: String = "allowed_tools"
    public var allowed_tools: ChatAllowedTools
}
@BaseModelNoWithExtra
public struct ChatNamedToolChoiceFunction {
    public var name: String
}
@BaseModelNoWithExtra
public struct ChatNamedToolChoiceCustom {
    public var name: String
}
@BaseModelNoWithExtra
public struct ChatNamedToolChoiceType {
    public static let type: String = "function"
    public var function: ChatNamedToolChoiceFunction
}
@BaseModelNoWithExtra
public struct ChatNamedToolChoiceCustomType {
    public static let type: String = "custom"
    public var custom: ChatNamedToolChoiceCustom
}
//@CodableTraversal
@CodableByConstantAndSingle(singleCase: "literal")
public enum ChatToolChoice {
    case literal(ChatToolChoiceLiteral)
    case allowed_tools(ChatAllowedToolChoiceType)
    case function(ChatNamedToolChoiceType)
    case custom(ChatNamedToolChoiceCustomType)
}

// MARK: - Response Format

@BaseModelNoWithExtra
public struct ChatJSONSchema {
    public var name: String
    public var description: String
    public var schema: [String: BaseType]
    public var strict: Bool?
}

@BaseModelNoWithExtra
public struct ChatResponseFormatText {
    public static let type: String = "text"
}

@BaseModelNoWithExtra
public struct ChatResponseFormatJSONSchema {
    public static let type: String = "json_schema"
    public var json_schema: ChatJSONSchema
}

@BaseModelNoWithExtra
public struct ChatResponseFormatJSONObject {
    public static let type: String = "json_object"
}

@CodableByConstant
public enum ChatResponseFormat {
    case text(ChatResponseFormatText)
    case json_schema(ChatResponseFormatJSONSchema)
    case json_object(ChatResponseFormatJSONObject)
}

// MARK: - Prediction Content

@BaseModelNoWithExtra
public struct ChatPredictionContent {
    public static let type: String = "content"
    public var content: ChatStringOrContentPartText
}

// MARK: - Web Search Option

@BaseModelNoWithExtra
public struct ChatWebSearchUserLocationApproximate {
    public var city: String
    public var country: String
    public var region: String
    public var timezone: String
}

@BaseModelNoWithExtra
public struct ChatWebSearchUserLocation {
    public static let type: String = "approximate"
    public var approximate: ChatWebSearchUserLocationApproximate
}

@CodableLiteral
public enum ChatSearchContextSizeLiteral: String {
    case low, medium, high
}

@BaseModelNoWithExtra
public struct ChatWebSearchOption {
    public var search_context_size: ChatSearchContextSizeLiteral?
    public var user_location: ChatWebSearchUserLocation?
}

// MARK: - Chat Parameters

public typealias ChatReasoningEffortLiteral = OpenAIReasoningEffortLiteral

@CodableLiteral
public enum ChatModalityLiteral: String {
    case text, audio
}

@CodableLiteral
public enum ChatPromptCacheRetentionLiteral: String {
    case inMemory = "in-memory"
    case h24 = "24h"
}

@CodableLiteral
public enum ChatServiceTierLiteral: String {
    case auto, `default`, flex, scale, priority
}

@CodableLiteral
public enum ChatVerbosityLiteral: String {
    case low, medium, high
}

public typealias ChatMetaData = OpenAIMetaData

@BaseModelWithExtra
public struct ChatParameters {
    public var model: String
    public var messages: [ChatMessage]
    public var stream: Bool?
    public var functions: [ChatFunction]?
    public var function_call: ChatFunctionCall?
    public var tools: [ChatTool]?
    public var tool_choice: ChatToolChoice?
    public var audio: ChatAudio?
    public var temperature: Double?
    public var top_p: Double?
    public var frequency_penalty: Double?
    public var presence_penalty: Double?
    public var max_tokens: Int?
    public var parallel_tool_calls: Bool?
    public var reasoning_effort: ChatReasoningEffortLiteral?
    public var stream_options: ChatStreamOptions?
    public var stop: [String]?
    public var response_format: ChatResponseFormat?
    public var modalities: [ChatModalityLiteral]?
    public var seed: Int?
    public var web_search_options: ChatWebSearchOption?
    public var metadata: ChatMetaData?
    public var max_completion_tokens: Int?
    public var logit_bias: [String: Int]?
    public var logprobs: Bool?
    public var n: Int?
    public var prediction: ChatPredictionContent?
    public var prompt_cache_key: String?
    public var prompt_cache_retention: ChatPromptCacheRetentionLiteral?
    public var safety_identifier: String?
    public var service_tier: ChatServiceTierLiteral?
    public var store: Bool?
    public var top_logprobs: Int?
    public var verbosity: ChatVerbosityLiteral?
    public var user: String?
}

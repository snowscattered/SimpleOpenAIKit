//
//  ChatParseParameters.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/10/5.
//

import Foundation
import SimpleCodableMacro

@PublicInit
public struct ChatParseParameters<T: SchemaProtocol> {
    public var model: String
    public var messages: [ChatMessage]
    public var response_format: T.Type?
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

extension ChatParseParameters {
    var createParameters: ChatParameters {
        .init(
            model: self.model,
            messages: self.messages,
            functions: self.functions,
            function_call: self.function_call,
            tools: self.tools,
            tool_choice: self.tool_choice,
            audio: self.audio,
            temperature: self.temperature,
            top_p: self.top_p,
            frequency_penalty: self.frequency_penalty,
            presence_penalty: self.presence_penalty,
            max_tokens: self.max_tokens,
            parallel_tool_calls: self.parallel_tool_calls,
            reasoning_effort: self.reasoning_effort,
            stream_options: self.stream_options,
            stop: self.stop,
            response_format: self.response_format.map { .init($0) },
            modalities: self.modalities,
            seed: self.seed,
            web_search_options: self.web_search_options,
            metadata: self.metadata,
            max_completion_tokens: self.max_completion_tokens,
            logit_bias: self.logit_bias,
            logprobs: self.logprobs,
            n: self.n,
            prediction: self.prediction,
            prompt_cache_key: self.prompt_cache_key,
            prompt_cache_retention: self.prompt_cache_retention,
            safety_identifier: self.safety_identifier,
            service_tier: self.service_tier,
            store: self.store,
            top_logprobs: self.top_logprobs,
            verbosity: self.verbosity,
            user: self.user
        )
    }
}

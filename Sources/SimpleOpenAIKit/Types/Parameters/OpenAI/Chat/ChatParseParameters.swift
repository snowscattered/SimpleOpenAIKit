//
//  ChatParseParameters.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/10/5.
//

import Foundation
import SimpleCodableMacro

//@BaseModelWithExtra(encodeExtra: false)
//@PublicInit
public struct ChatParseParameters<T: SchemaProtocol> {
    public var model: String
    public var messages: [ChatMessage]
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
    public var response_format: T.Type?
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
    
    
    public init(
        model: String,
        messages: [ChatMessage],
        functions: [ChatFunction]? = nil,
        function_call: ChatFunctionCall? = nil,
        tools: [ChatTool]? = nil,
        tool_choice: ChatToolChoice? = nil,
        audio: ChatAudio? = nil,
        temperature: Double? = nil,
        top_p: Double? = nil,
        frequency_penalty: Double? = nil,
        presence_penalty: Double? = nil,
        max_tokens: Int? = nil,
        parallel_tool_calls: Bool? = nil,
        reasoning_effort: ChatReasoningEffortLiteral? = nil,
        stream_options: ChatStreamOptions? = nil,
        stop: [String]? = nil,
        response_format: T.Type? = nil,
        modalities: [ChatModalityLiteral]? = nil,
        seed: Int? = nil,
        web_search_options: ChatWebSearchOption? = nil,
        metadata: ChatMetaData? = nil,
        max_completion_tokens: Int? = nil,
        logit_bias: [String: Int]? = nil,
        logprobs: Bool? = nil,
        n: Int? = nil,
        prediction: ChatPredictionContent? = nil,
        prompt_cache_key: String? = nil,
        prompt_cache_retention: ChatPromptCacheRetentionLiteral? = nil,
        safety_identifier: String? = nil,
        service_tier: ChatServiceTierLiteral? = nil,
        store: Bool? = nil,
        top_logprobs: Int? = nil,
        verbosity: ChatVerbosityLiteral? = nil,
        user: String? = nil
    ) {
        self.model = model
        self.messages = messages
        self.functions = functions
        self.function_call = function_call
        self.tools = tools
        self.tool_choice = tool_choice
        self.audio = audio
        self.temperature = temperature
        self.top_p = top_p
        self.frequency_penalty = frequency_penalty
        self.presence_penalty = presence_penalty
        self.max_tokens = max_tokens
        self.parallel_tool_calls = parallel_tool_calls
        self.reasoning_effort = reasoning_effort
        self.stream_options = stream_options
        self.stop = stop
        self.response_format = response_format
        self.modalities = modalities
        self.seed = seed
        self.web_search_options = web_search_options
        self.metadata = metadata
        self.max_completion_tokens = max_completion_tokens
        self.logit_bias = logit_bias
        self.logprobs = logprobs
        self.n = n
        self.prediction = prediction
        self.prompt_cache_key = prompt_cache_key
        self.prompt_cache_retention = prompt_cache_retention
        self.safety_identifier = safety_identifier
        self.service_tier = service_tier
        self.store = store
        self.top_logprobs = top_logprobs
        self.verbosity = verbosity
        self.user = user
    }
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

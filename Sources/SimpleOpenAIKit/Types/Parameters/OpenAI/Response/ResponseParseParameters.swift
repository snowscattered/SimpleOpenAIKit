//
//  ResponseParseParameters.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/10/7.
//

import Foundation
import SimpleCodableMacro

@PublicInit
public struct ResponseParseParameters<T: SchemaProtocol> {
    public var model: String
    public var instructions: String?
    public var input: ResponseInputOrItems?
    public var text_format: T.Type?
    public var stream: Bool?
    public var previous_response_id: String?
    public var conversation: ResponseConversation?
    public var parallel_tool_calls: Bool?
    public var tools: [ResponseTool]?
    public var tool_choice: ResponseToolChoice?
    public var reasoning: ResponseReasoning?
    public var max_tool_calls: Int?
    public var max_output_tokens: Int?
    public var temperature: Double?
    public var top_p: Double?
    public var store: Bool?
    public var include: [ResponseIncludeLiteral]?
    public var context_management: ResponseContextManagement?
    public var stream_options: ResponseStreamOptions?
    public var background: Bool?
    public var metadata: ResponseMetaData?
    public var moderation: ResponseModeration?
    public var prompt: ResponsePrompt?
    public var prompt_cache_key: String?
    public var prompt_cache_options: ResponsePromptCacheOption?
    public var prompt_cache_retention: ResponsePromptCacheRetentionLiteral?
    public var safety_identifier: String?
    public var service_tier: ResponseServiceTierLiteral?
    public var top_logprobs: Int?
    public var truncation: ResponseTruncationLiteral?
    public var user: String?
}

extension ResponseParseParameters {
    var createParameters: ResponseCreateParameters {
        .init(
            model: self.model,
            instructions: self.instructions,
            input: self.input,
            stream: self.stream,
            previous_response_id: self.previous_response_id,
            conversation: self.conversation,
            parallel_tool_calls: self.parallel_tool_calls,
            tools: self.tools,
            tool_choice: self.tool_choice,
            reasoning: self.reasoning,
            max_tool_calls: self.max_tool_calls,
            max_output_tokens: self.max_output_tokens,
            temperature: self.temperature,
            top_p: self.top_p,
            store: self.store,
            include: self.include,
            context_management: self.context_management,
            stream_options: self.stream_options,
            text: self.text_format.map {
                ResponseTextConfig(format: ResponseFormatTextConfig($0))
            },
            background: self.background,
            metadata: self.metadata,
            moderation: self.moderation,
            prompt: self.prompt,
            prompt_cache_key: self.prompt_cache_key,
            prompt_cache_options: self.prompt_cache_options,
            prompt_cache_retention: self.prompt_cache_retention,
            safety_identifier: self.safety_identifier,
            service_tier: self.service_tier,
            top_logprobs: self.top_logprobs,
            truncation: self.truncation,
            user: self.user
        )
    }
}

//
//  ResponseParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelWithExtra
public struct ResponseCreateParameters {
    public var model: String
    public var instructions: String?
    public var input: ResponseInputOrItems?
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
    public var text: ResponseTextConfig?
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

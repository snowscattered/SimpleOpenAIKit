//
//  ChatCommon.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/10/26.
//
import Foundation
import SimpleCodableMacro

// ChatResult.Choice.Logprobs
@BaseModelNoWithExtra
@PublicInit
public struct ChatTopLogprob {
    public let token: String
    public let bytes: [Int]?
    public let logprob: Float
}
@BaseModelNoWithExtra
@PublicInit
public struct ChatTokenLogprob {
    public let token: String
    public let bytes: [Int]?
    public let logprob: Float
    public let top_logprobs: [ChatTopLogprob]
}
@BaseModelNoWithExtra
@PublicInit
public struct ChatLogprobs {
    public let content: [ChatTokenLogprob]?
    public let refusal: [ChatTokenLogprob]?
}

// ChatResult.Choice.FinshReason
@CodableLiteral
public enum ChatChoiceFinshReason: String {
    case stop
    case length
    case tool_calls
    case content_filter
    case function_call
}

// ChatResult.Usage
@BaseModelWithExtra
@PublicInit
public struct ChatCompletionTokensDetails {
    public let accepted_prediction_tokens: Int?
    public let audio_tokens: Int?
    public let reasoning_tokens: Int?
    public let rejected_prediction_tokens: Int?
}
@BaseModelWithExtra
@PublicInit
public struct ChatPromptTokensDetails {
    public let audio_tokens: Int?
    public let cached_tokens: Int?
}
@BaseModelWithExtra
@PublicInit
public struct ChatUsage {
    public let completion_tokens: Int
    public let prompt_tokens: Int
    public let total_tokens: Int
    public let completion_tokens_details: ChatCompletionTokensDetails?
    public let prompt_tokens_details: ChatPromptTokensDetails?
}

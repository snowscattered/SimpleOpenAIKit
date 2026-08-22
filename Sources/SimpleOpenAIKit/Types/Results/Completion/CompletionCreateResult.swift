//
//  CompletionResult.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/8/26.
//

import Foundation
import SimpleCodableMacro

// CompletionResult.choice
@BaseModelNoWithExtra
public struct CompletionChoiceLogprobs {
    public let text_offset: [Int]?
    public let token_logprobs: [Float]?
    public let tokens: [String]?
    public let top_logprobs: [[String: Float]]?
}
@CodableLiteral
public enum CompletionChoiceFinishReason: String {
    case stop
    case length
    case content_filter
}
@BaseModelNoWithExtra
public struct CompletionResultChoice {
    public let finish_reason: CompletionChoiceFinishReason?
    public let index: Int
    public let logprobs: CompletionChoiceLogprobs?
    public let text: String
}
// CompletionResult.Usage
@BaseModelNoWithExtra
public struct CompletionTokensDetails {
    public let accepted_prediction_tokens: Int?
    public let audio_tokens: Int?
    public let reasoning_tokens: Int?
    public let rejected_prediction_tokens: Int?
}
@BaseModelNoWithExtra
public struct CompletionPromptTokensDetails {
    public let audio_tokens: Int?
    public let cached_tokens: Int?
}
@BaseModelNoWithExtra
public struct CompletionUsage {
    public let completion_tokens: Int
    public let prompt_tokens: Int
    public let total_tokens: Int
    public let completion_tokens_details: CompletionTokensDetails?
    public let prompt_tokens_details: CompletionPromptTokensDetails?
}
// CompletionResult
@BaseModelNoWithExtra
public struct CompletionCreateResult {
    public let id: String
    public let choices: [CompletionResultChoice]
    public let created: Int
    public let model: String
    public static let object: String = "text_completion"
    public let system_fingerprint: String?
    public let usage: CompletionUsage?
}

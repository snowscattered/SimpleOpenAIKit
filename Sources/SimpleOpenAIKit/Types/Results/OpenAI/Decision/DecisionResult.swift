//
//  DecisionResult.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/10/7.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct DecisionUsageInputTokensDetails {
    public let cache_write_tokens: Int
    public let cached_tokens: Int
}

@BaseModelNoWithExtra
@PublicInit
public struct DecisionUsageOutputTokensDetails {
    public let reasoning_tokens: Int
}

@BaseModelNoWithExtra
@PublicInit
public struct DecisionUsage {
    public let input_tokens: Int
    public let input_tokens_details: DecisionUsageInputTokensDetails
    public let output_tokens: Int
    public let output_tokens_details: DecisionUsageOutputTokensDetails
    public let total_tokens: Int
}

@BaseModelNoWithExtra
@PublicInit
public struct DecisionResult {
    public let answers: [DecisionAnswer]
    public let model: String
    public let usage: DecisionUsage
}

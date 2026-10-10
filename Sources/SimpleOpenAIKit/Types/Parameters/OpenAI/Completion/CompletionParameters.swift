//
//  CompletionParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

// MARK: - Stream Options

@BaseModelNoWithExtra
@PublicInit
public struct CompletionStreamOptions {
    public var include_obfuscation: Bool?
    public var include_usage: Bool?
}

// MARK: - Completion Prompt
@SingleOrArray
public enum CompletionPrompt {
    case string(String)
    case array([String])
}

// MARK: - Completion Stop

@SingleOrArray
public enum CompletionStop {
    case string(String)
    case array([String])
}

// MARK: - Completion Param Model

@BaseModelWithExtra(encodeExtra: false)
@PublicInit
public struct CompletionParameters {
    public var model: String
    public var prompt: CompletionPrompt?
    public var stream: Bool?
    public var suffix: String?
    public var frequency_penalty: Double?
    public var presence_penalty: Double?
    public var temperature: Double?
    public var top_p: Double?
    public var max_tokens: Int?
    public var stop: CompletionStop?
    public var seed: Int?
    public var logprobs: Int?
    public var logit_bias: [String: Int]?
    public var best_of: Int?
    public var echo: Bool?
    public var n: Int?
    public var stream_options: CompletionStreamOptions?
    public var user: String?
}

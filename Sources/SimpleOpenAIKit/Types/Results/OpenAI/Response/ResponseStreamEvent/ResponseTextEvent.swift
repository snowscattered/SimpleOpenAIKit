//
//  ResponseTextEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct ResponseTextTopLogprob {
    public let token: String?
    public let logprob: Float?
}
@BaseModelNoWithExtra
@PublicInit
public struct ResponseTextLogprob {
    public let token: String
    public let logprob: Float
    public let top_logprobs: [ResponseTextTopLogprob]?
}
@BaseModelNoWithExtra
@PublicInit
public struct ResponseTextDeltaEvent {
    public static let type: String = "response.output_text.delta"
    public let content_index: Int
    public let delta: String
    public let item_id: String
    public let output_index: Int
    public let sequence_number: Int
    public let logprobs: [ResponseTextLogprob]?
}
@BaseModelNoWithExtra
@PublicInit
public struct ResponseTextDoneEvent {
    public static let type: String = "response.output_text.done"
    public let content_index: Int
    public let item_id: String
    public let output_index: Int
    public let sequence_number: Int
    public let text: String
    public let logprobs: [ResponseTextLogprob]?
}

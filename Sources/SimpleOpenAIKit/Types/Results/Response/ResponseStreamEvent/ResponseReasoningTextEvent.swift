//
//  ResponseReasoningTextEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ResponseReasoningTextDeltaEvent {
    public static let type: String = "response.reasoning_text.delta"
    public let content_index: Int
    public let delta: String
    public let item_id: String
    public let output_index: Int
    public let sequence_number: Int
}
@BaseModelNoWithExtra
public struct ResponseReasoningTextDoneEvent {
    public static let type: String = "response.reasoning_text.done"
    public let content_index: Int
    public let item_id: String
    public let output_index: Int
    public let sequence_number: Int
    public let text: String
}

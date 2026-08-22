//
//  ResponseReasoningSummaryTextEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ResponseReasoningSummaryTextDeltaEvent {
    public static let type: String = "response.reasoning_summary_text.delta"
    public let delta: String
    public let item_id: String
    public let output_index: Int
    public let sequence_number: Int
    public let summary_index: Int
}
@BaseModelNoWithExtra
public struct ResponseReasoningSummaryTextDoneEvent {
    public static let type: String = "response.reasoning_summary_text.done"
    public let item_id: String
    public let output_index: Int
    public let sequence_number: Int
    public let summary_index: Int
    public let text: String
}

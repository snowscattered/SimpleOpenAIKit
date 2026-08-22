//
//  ResponseReasoningSummaryPartEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro


@BaseModelNoWithExtra
public struct ResponseSummaryTextPart {
    public let text: String
    public static let type: String = "summary_text"
}
@BaseModelNoWithExtra
public struct ResponseReasoningSummaryPartAddedEvent {
    public static let type: String = "response.reasoning_summary_part.added"
    public let item_id: String
    public let output_index: Int
    public let part: ResponseSummaryTextPart
    public let sequence_number: Int
    public let summary_index: Int
}
@BaseModelNoWithExtra
public struct ResponseReasoningSummaryPartDoneEvent {
    public static let type: String = "response.reasoning_summary_part.done"
    public let item_id: String
    public let output_index: Int
    public let part: ResponseSummaryTextPart
    public let sequence_number: Int
    public let summary_index: Int
}

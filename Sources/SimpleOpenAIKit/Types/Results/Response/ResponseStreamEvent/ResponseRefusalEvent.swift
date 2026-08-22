//
//  ResponseRefusalEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ResponseRefusalDeltaEvent {
    public static let type: String = "response.refusal.delta"
    public let content_index: Int
    public let delta: String
    public let item_id: String
    public let output_index: Int
    public let sequence_number: Int
}
@BaseModelNoWithExtra
public struct ResponseRefusalDoneEvent {
    public static let type: String = "response.refusal.done"
    public let content_index: Int
    public let item_id: String
    public let output_index: Int
    public let refusal: String
    public let sequence_number: Int
}

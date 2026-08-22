//
//  MessageDeltaEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct MessageDelta {
    public let container: MessageContainer?
    public let stop_details: MessageRefusalStopDetails?
    public let stop_reason: MessageStopReason?
    public let stop_sequence: String?
}
@BaseModelNoWithExtra
public struct MessageDeltaUsage {
    public let cache_creation_input_tokens: Int?
    public let cache_read_input_tokens: Int?
    public let input_tokens: Int?
    public let output_tokens: Int
    public let server_tool_use: MessageServerToolUsage?
}
@BaseModelNoWithExtra
public struct MessageDeltaEvent {
    public static let type: String = "message_delta"
    public let delta: MessageDelta
    public let usage: MessageDeltaUsage
}

//
//  MessageShare.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

// MessageCreateResult.Container
@BaseModelNoWithExtra
public struct MessageContainer {
    public let id: String
    public let expires_at: String
}

// MessageCreateResult.StopDetails
@BaseModelNoWithExtra
public struct MessageRefusalStopDetails {
    public let category: String?
    public let explanation: String?
    public static let type: String = "refusal"
}

// MessageCreateResult.StopReason
@CodableLiteral
public enum MessageStopReason: String {
    case end_turn
    case max_tokens
    case stop_sequence
    case tool_use
    case pause_turn
    case refusal
}

// MessageCreateResult.Usage (shared: MessageUsage, MessageDeltaUsage)
@BaseModelNoWithExtra
public struct MessageServerToolUsage {
    public let web_fetch_requests: Int?
    public let web_search_requests: Int?
}

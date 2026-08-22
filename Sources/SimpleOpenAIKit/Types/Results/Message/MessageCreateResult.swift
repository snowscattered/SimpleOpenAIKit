//
//  MessageCreateResult.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

// MessageCreateResult.Usage
@BaseModelNoWithExtra
public struct MessageCacheCreation {
    public let ephemeral_1h_input_tokens: Int
    public let ephemeral_5m_input_tokens: Int
}
@BaseModelNoWithExtra
public struct MessageUsage {
    public let cache_creation: MessageCacheCreation?
    public let cache_creation_input_tokens: Int?
    public let cache_read_input_tokens: Int?
    public let inference_geo: String?
    public let input_tokens: Int
    public let output_tokens: Int
    public let server_tool_use: MessageServerToolUsage?
    public let service_tier: String?
}

@BaseModelNoWithExtra
public struct MessageCreateResult {
    public static let role: String = "assistant"
    public static let type: String = "message"
    public let id: String
    public let container: MessageContainer?
    public let content: [MessageBlock]
    public let model: String
    public let stop_details: MessageRefusalStopDetails?
    public let stop_reason: MessageStopReason?
    public let stop_sequence: String?
    public let usage: MessageUsage
}

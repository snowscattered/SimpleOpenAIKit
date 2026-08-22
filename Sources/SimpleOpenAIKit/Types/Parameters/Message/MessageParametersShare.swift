//
//  MessageSupport.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

// MARK: - Cache Control
@CodableLiteral
public enum MessageCacheControlTTL: String {
    case fiveMinutes = "5m"
    case oneHour = "1h"
}

@BaseModelNoWithExtra
public struct MessageCacheControlEphemeral {
    public static let type: String = "ephemeral"
    public var ttl: MessageCacheControlTTL
}

// MARK: - System
@SingleOrArray
public enum MessageSystem {
    case string(String)
    case array([MessageTextBlock])
}
extension MessageSystem: ExpressibleByStringLiteral, ExpressibleByArrayLiteral {
    public init(stringLiteral value: String)                { self = .string(value) }
    public init(arrayLiteral elements: MessageTextBlock...) { self = .array(elements) }
}

// MARK: - Tool Choice
@CodableLiteral
public enum MessageToolChoiceType: String {
    case auto, any, tool, none
}

@BaseModelNoWithExtra
public struct MessageToolChoice {
    public var type: MessageToolChoiceType
    public var disable_parallel_tool_use: Bool?
    public var name: String?
}

// MARK: - Thinking
@CodableLiteral
public enum MessageThinkingType: String {
    case enabled, disabled, adaptive
}

@CodableLiteral
public enum MessageThinkingDisplay: String {
    case summarized, omitted
}

@BaseModelNoWithExtra
public struct MessageThinking {
    public var type: MessageThinkingType
    public var budget_tokens: Int?
    public var display: MessageThinkingDisplay?
}

// MARK: - Metadata
@BaseModelNoWithExtra
public struct MessageMetadata {
    public var user_id: String?
}

// MARK: - Output Config
@CodableLiteral
public enum MessageEffortLiteral: String {
    case low, medium, high, max
}

@BaseModelNoWithExtra
public struct MessageJSONOutputFormat {
    public static let type: String = "json_schema"
    public var schema: [String: BaseType]
}

@BaseModelNoWithExtra
public struct MessageOutputConfig {
    public let effort: MessageEffortLiteral
    public let format: MessageJSONOutputFormat?
}

// MARK: - DocumentBlock | MessageTool
@BaseModelNoWithExtra
public struct MessageCitationsConfig {
    public let enabled: Bool
}

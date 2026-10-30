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
    case `5m`, `1h`
}

@BaseModelNoWithExtra
@PublicInit
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

// MARK: - Tool Choice
@BaseModelNoWithExtra
@PublicInit
public struct MessageToolChoiceAuto {
    public static let type: String = "auto"
    public var disable_parallel_tool_use: Bool?
}
@BaseModelNoWithExtra
@PublicInit
public struct MessageToolChoiceAny {
    public static let type: String = "any"
    public var disable_parallel_tool_use: Bool?
}
@BaseModelNoWithExtra
@PublicInit
public struct MessageToolChoiceTool {
    public static let type: String = "tool"
    public var name: String
    public var disable_parallel_tool_use: Bool?
}
@BaseModelNoWithExtra
@PublicInit
public struct MessageToolChoiceNone {
    public static let type: String = "none"
}
@CodableByConstant
public enum MessageToolChoice {
    case auto(MessageToolChoiceAuto)
    case any(MessageToolChoiceAny)
    case tool(MessageToolChoiceTool)
    case none(MessageToolChoiceNone)
}

// MARK: - Thinking
@CodableLiteral
public enum MessageThinkingDisplay: String {
    case summarized, omitted
}
@BaseModelNoWithExtra
@PublicInit
public struct MessageThinkingEnabled {
    public static let type: String = "enabled"
    public var budget_tokens: Int
    public var display: MessageThinkingDisplay?
}
@BaseModelNoWithExtra
@PublicInit
public struct MessageThinkingDisabled {
    public static let type: String = "disabled"
}
@BaseModelNoWithExtra
@PublicInit
public struct MessageThinkingBetweenTools {
    public static let type: String = "between_tools"
}
@BaseModelNoWithExtra
@PublicInit
public struct MessageThinkingAdaptive {
    public static let type: String = "adaptive"
    public var display: MessageThinkingDisplay?
}
@CodableByConstant
public enum MessageThinking {
    case enabled(MessageThinkingEnabled)
    case disabled(MessageThinkingDisabled)
    case between_tools(MessageThinkingBetweenTools)
    case adaptive(MessageThinkingAdaptive)
}

// MARK: - Metadata
@BaseModelNoWithExtra
@PublicInit
public struct MessageMetadata {
    public var user_id: String?
}

// MARK: - Output Config
@CodableLiteral
public enum MessageEffortLiteral: String {
    case low, medium, high, xhigh, max
}

@BaseModelNoWithExtra
@PublicInit
public struct MessageJSONOutputFormat {
    public static let type: String = "json_schema"
    public var schema: [String: BaseType]
}

@BaseModelNoWithExtra
@PublicInit
public struct MessageOutputConfig {
    public let effort: MessageEffortLiteral?
    public let format: MessageJSONOutputFormat?
}

// MARK: - DocumentBlock | MessageTool
@BaseModelNoWithExtra
@PublicInit
public struct MessageCitationsConfig {
    public let enabled: Bool
}

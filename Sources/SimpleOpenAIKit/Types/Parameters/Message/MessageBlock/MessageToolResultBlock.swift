//
//  MessageToolResultBlock.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct MessageToolReference {
    public static let type: String = "tool_reference"
    public var tool_name: String
    public var cache_control: MessageCacheControlEphemeral?
}

// MARK: - Content (Tool Result Items)

@CodableByConstant
public enum MessageToolContent {
    case text(MessageTextBlock)
    case image(MessageImageBlock)
    case document(MessageDocumentBlock)
    case tool_reference(MessageToolReference)
}

@SingleOrArray
public enum MessageToolResultContent {
    case string(String)
    case array([MessageToolContent])
}
extension MessageToolResultContent: ExpressibleByStringLiteral, ExpressibleByArrayLiteral {
    public init(stringLiteral value: String)                  { self = .string(value) }
    public init(arrayLiteral elements: MessageToolContent...) { self = .array(elements) }
}

@BaseModelNoWithExtra
public struct MessageToolResultBlock {
    public static let type: String = "tool_result"
    public var tool_use_id: String
    public var content: MessageToolResultContent
    public var is_error: Bool?
}

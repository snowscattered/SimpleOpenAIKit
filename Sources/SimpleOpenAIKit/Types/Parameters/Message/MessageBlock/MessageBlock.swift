//
//  MessageBlock.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

// MARK: - Block Union

@CodableByConstant
@nonexhaustive
public enum MessageBlock {
    case text(MessageTextBlock)
    case thinking(MessageThinkingBlock)
    case image(MessageImageBlock)
    case video(MessageVideoBlock)
    case document(MessageDocumentBlock)
    
    case tool_use(MessageToolUseBlock)
    case tool_result(MessageToolResultBlock)
    case search_result(MessageSearchResultBlock)
    case server_tool_use(MessageServerToolUseBlock)
    case web_search_result(MessageWebSearchToolResultBlock)
    case web_fetch_result(MessageWebFetchToolResultBlock)
}

// MARK: - Message Content Input
@SingleOrArray
public enum MessageContentInput {
    case string(String)
    case array([MessageBlock])
}
extension MessageContentInput: ExpressibleByStringLiteral, ExpressibleByArrayLiteral {
    public init(stringLiteral value: String)            { self = .string(value) }
    public init(arrayLiteral elements: MessageBlock...) { self = .array(elements) }
}

// MARK: - Message
@CodableLiteral
public enum MessageRole: String {
    case user, assistant, system
}

@BaseModelNoWithExtra
public struct MessageMessages {
    public let role: MessageRole
    public let content: MessageContentInput
}
extension MessageMessages {
    public static func system(_ content: MessageContentInput) -> Self {
        return MessageMessages(role: .system, content: content)
    }
    public static func user(_ content: MessageContentInput) -> Self {
        return MessageMessages(role: .user, content: content)
    }
    public static func assistant(_ content: MessageContentInput) -> Self {
        return MessageMessages(role: .assistant, content: content)
    }
}

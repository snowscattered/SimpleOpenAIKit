//
//  MessageMessages.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/11/11.
//

import Foundation
import SimpleCodableMacro

// MARK: - Message Content Input
@SingleOrArray
public enum MessageContent {
    case string(String)
    case array([MessageBlock])
}

// MARK: - Message
@CodableLiteral
public enum MessageRole: String {
    case user, assistant, system
}

@BaseModelNoWithExtra
@PublicInit
public struct MessageMessages {
    public let role: MessageRole
    public let content: MessageContent
}
public extension MessageMessages {
    static func system(_ content: MessageContent) -> Self {
        return MessageMessages(role: .system, content: content)
    }
    static func user(_ content: MessageContent) -> Self {
        return MessageMessages(role: .user, content: content)
    }
    static func assistant(_ content: MessageContent) -> Self {
        return MessageMessages(role: .assistant, content: content)
    }
    // ...
}

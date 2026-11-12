//
//  ChatMessage.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelWithExtra
@PublicInit
public struct CustomMessage {
    public var role: String
}

@CodableByConstant(field: "role", defaultCase: "custom")
@nonexhaustive
public enum ChatMessage {
    case developer(ChatDeveloperMessage)
    case system(ChatSystemMessage)
    case user(ChatUserMessage)
    case assistant(ChatAssistantMessage)
    case tool(ChatToolMessage)
    case function(ChatFunctionMessage)
    // Extension OpenAI
    case custom(CustomMessage)
}

public extension ChatMessage {
    static func developer(_ text: String) -> Self {
        .developer(.init(content: .string(text)))
    }
    static func system(_ text: String) -> Self {
        .system(.init(content: .string(text)))
    }
    static func user(_ text: String) -> Self {
        .user(.init(content: .string(text)))
    }
    static func assistant(_ text: String, reason: String?) -> Self {
        .assistant(.init(content: .string(text), reasoning_content: reason))
    }
}

//
//  ChatMessage.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelWithExtra
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
extension ChatMessage {
    var role: String {
        switch self {
        case .developer:         return ChatDeveloperMessage.role
        case .system:            return ChatSystemMessage.role
        case .user:              return ChatUserMessage.role
        case .assistant:         return ChatAssistantMessage.role
        case .tool:              return ChatToolMessage.role
        case .function:          return ChatFunctionMessage.role
        case .custom(let event): return event.role
        }
    }
}

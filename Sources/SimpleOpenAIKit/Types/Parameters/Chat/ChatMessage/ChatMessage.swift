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

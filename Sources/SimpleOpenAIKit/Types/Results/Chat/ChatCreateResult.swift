//
//  ChatResult.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/8/26.
//
import Foundation
import SimpleCodableMacro

public typealias ChatCreateMessage = ChatAssistantMessage

@BaseModelNoWithExtra
public struct ChatCreateChoice {
    public let index: Int
    public let message: ChatCreateMessage
    public let finish_reason: ChatChoiceFinshReasonLiteral
    public let logprobs: ChatLogprobs?
}
// ChatResult
@BaseModelNoWithExtra
public struct ChatCreateResult {
    public let id: String
    public let choices: [ChatCreateChoice]
    public let created: Int
    public let model: String
    public static let object: String = "chat.completion"
    public let service_tier: ChatServiceTier?
    public let system_fingerprint: String?
    public let usage: ChatUsage?
}

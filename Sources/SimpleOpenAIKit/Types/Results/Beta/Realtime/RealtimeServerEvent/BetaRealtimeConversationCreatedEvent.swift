//
//  BetaRealtimeConversationCreatedEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeConversation {
    public static let object: String = "realtime.conversation"
    public let id: String?
}

@BaseModelNoWithExtra
public struct BetaRealtimeConversationCreatedEvent {
    public static let type: String = "conversation.created"
    public let conversation: BetaRealtimeConversation
    public let event_id: String
}

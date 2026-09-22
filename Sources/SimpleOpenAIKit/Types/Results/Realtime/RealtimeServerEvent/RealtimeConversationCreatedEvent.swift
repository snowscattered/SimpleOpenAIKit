//
//  RealtimeConversationCreatedEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/20/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct RealtimeConversation {
    public static let object: String = "realtime.conversation"
    public let id: String?
}

@BaseModelNoWithExtra
@PublicInit
public struct RealtimeConversationCreatedEvent {
    public static let type: String = "conversation.created"
    public let event_id: String
    public let conversation: RealtimeConversation
}

//
//  BetaRealtimeConversationItemTruncatedEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/20/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeConversationItemTruncatedEvent {
    public static let type: String = "conversation.item.truncated"
    public let event_id: String
    public let item_id: String
    public let content_index: Int
    public let audio_end_ms: Int
}

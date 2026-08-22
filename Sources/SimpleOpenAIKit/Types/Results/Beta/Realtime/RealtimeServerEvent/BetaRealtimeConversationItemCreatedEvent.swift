//
//  BetaRealtimeConversationItemCreatedEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeConversationItemCreatedEvent {
    public static let type: String = "conversation.item.created"
    public let event_id: String
    public let item: BetaRealtimeConversationItem
    public let previous_item_id: String?
}

//
//  RealtimeConversationItemCreatedEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/20/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct RealtimeConversationItemCreatedEvent {
    public static let type: String = "conversation.item.created"
    public let event_id: String
    public let item: RealtimeConversationItem
    public let previous_item_id: String?
}

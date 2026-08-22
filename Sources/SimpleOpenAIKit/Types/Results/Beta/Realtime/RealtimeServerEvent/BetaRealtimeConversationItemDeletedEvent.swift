//
//  BetaRealtimeConversationItemDeletedEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeConversationItemDeletedEvent {
    public static let type: String = "conversation.item.deleted"
    public let event_id: String
    public let item_id: String
}

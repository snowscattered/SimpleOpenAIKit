//
//  BetaRealtimeConversationItemRetrievedEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/20/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeConversationItemRetrievedEvent {
    public static let type: String = "conversation.item.retrieved"
    public let event_id: String
    public let item_id: String
}

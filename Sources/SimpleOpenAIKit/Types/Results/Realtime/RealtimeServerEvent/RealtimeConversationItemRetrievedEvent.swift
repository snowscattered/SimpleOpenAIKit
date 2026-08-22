//
//  RealtimeConversationItemRetrievedEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/20/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct RealtimeConversationItemRetrievedEvent {
    public static let type: String = "conversation.item.retrieved"
    public let event_id: String
    public let item: RealtimeConversationItem
}

//
//  RealtimeConversationItemCreateEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/14/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct RealtimeConversationItemCreateEventParameters {
    public static let type: String = "conversation.item.create"
    public var event_id: String?
    public var item: RealtimeConversationItem
    public var previous_item_id: String?
}

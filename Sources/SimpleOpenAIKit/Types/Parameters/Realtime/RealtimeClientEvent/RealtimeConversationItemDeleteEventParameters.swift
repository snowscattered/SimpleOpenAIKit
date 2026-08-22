//
//  RealtimeConversationItemDeleteEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/14/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct RealtimeConversationItemDeleteEventParameters {
    public static let type: String = "conversation.item.delete"
    public var event_id: String?
    public var item_id: String
}

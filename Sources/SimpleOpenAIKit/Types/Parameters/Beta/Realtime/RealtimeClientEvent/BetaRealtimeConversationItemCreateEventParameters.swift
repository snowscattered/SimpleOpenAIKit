//
//  BetaRealtimeConversationItemCreateEventParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeConversationItemCreateEventParameters {
    public static let type: String = "conversation.item.create"
    public var event_id: String?
    public var item: BetaRealtimeConversationItem
    public var previous_item_id: String?
}

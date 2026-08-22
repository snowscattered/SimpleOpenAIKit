//
//  BetaRealtimeConversationItemDeleteEventParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeConversationItemDeleteEventParameters {
    public static let type: String = "conversation.item.delete"
    public var event_id: String?
    public var item_id: String
}

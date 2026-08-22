//
//  BetaRealtimeConversationItemRetrieveEventParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeConversationItemRetrieveEventParameters {
    public static let type: String = "conversation.item.retrieve"
    public var event_id: String?
    public var item_id: String
}

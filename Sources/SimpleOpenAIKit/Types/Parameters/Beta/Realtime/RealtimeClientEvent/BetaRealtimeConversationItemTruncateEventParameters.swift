//
//  BetaRealtimeConversationItemTruncateEventParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeConversationItemTruncateEventParameters {
    public static let type: String = "conversation.item.truncate"
    public var event_id: String?
    public var item_id: String
    public var audio_end_ms: Int
    public var content_index: Int
}

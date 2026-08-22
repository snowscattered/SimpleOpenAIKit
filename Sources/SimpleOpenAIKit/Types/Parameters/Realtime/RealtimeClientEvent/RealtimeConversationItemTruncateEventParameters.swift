//
//  RealtimeConversationItemTruncateEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/14/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct RealtimeConversationItemTruncateEventParameters {
    public static let type: String = "conversation.item.truncate"
    public var event_id: String?
    public var item_id: String
    public var content_index: Int
    public var audio_end_ms: Int
}

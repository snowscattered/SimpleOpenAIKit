//
//  BetaRealtimeResponseOutputItemAddedEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeResponseOutputItemAddedEvent {
    public static let type: String = "response.output_item.added"
    public let event_id: String
    public let response_id: String
    public let output_index: Int
    public let item: BetaRealtimeConversationItem
}

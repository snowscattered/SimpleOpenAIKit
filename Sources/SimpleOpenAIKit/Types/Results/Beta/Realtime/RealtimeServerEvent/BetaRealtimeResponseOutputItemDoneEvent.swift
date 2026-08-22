//
//  BetaRealtimeResponseOutputItemDoneEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeResponseOutputItemDoneEvent {
    public static let type: String = "response.output_item.done"
    public let event_id: String
    public let response_id: String
    public let output_index: Int
    public let item: BetaRealtimeConversationItem
}

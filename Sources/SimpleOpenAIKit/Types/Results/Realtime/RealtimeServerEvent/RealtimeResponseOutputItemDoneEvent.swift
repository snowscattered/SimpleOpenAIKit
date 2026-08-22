//
//  RealtimeResponseOutputItemDoneEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/20/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct RealtimeResponseOutputItemDoneEvent {
    public static let type: String = "response.output_item.done"
    public let event_id: String
    public let response_id: String
    public let output_index: Int
    public let item: RealtimeConversationItem
}

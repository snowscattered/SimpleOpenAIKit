//
//  BetaRealtimeResponseContentPartAddedEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeResponseContentPartAddedEvent {
    public static let type: String = "response.content_part.added"
    public let event_id: String
    public let response_id: String
    public let item_id: String
    public let output_index: Int
    public let content_index: Int
    public let part: BetaRealtimePart
}

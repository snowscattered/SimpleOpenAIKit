//
//  BetaRealtimeResponseCreatedEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeResponseCreatedEvent {
    public static let type: String = "response.created"
    public let event_id: String
    public let response: BetaRealtimeResponseResult
}

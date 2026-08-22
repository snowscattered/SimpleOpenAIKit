//
//  BetaRealtimeSessionUpdatedEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeSessionUpdatedEvent {
    public static let type: String = "session.updated"
    public let event_id: String
    public let session: BetaRealtimeSession
}

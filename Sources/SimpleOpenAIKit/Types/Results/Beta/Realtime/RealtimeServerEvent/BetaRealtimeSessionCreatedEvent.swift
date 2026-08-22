//
//  BetaRealtimeSessionCreatedEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeSessionCreatedEvent {
    public static let type: String = "session.created"
    public let event_id: String
    public let session: BetaRealtimeSession
}

//
//  BetaRealtimeTranscriptionSessionUpdatedEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeTranscriptionSessionUpdatedEvent {
    public static let type: String = "realtime.updated"
    public let event_id: String
    public let session: BetaRealtimeTranscriptionSession
}

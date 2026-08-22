//
//  RealtimeSessionUpdateEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/20/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct RealtimeSessionUpdatedEvent {
    public static let type: String = "realtime.updated"
    public let event_id: String
    public let session: RealtimeSession
}

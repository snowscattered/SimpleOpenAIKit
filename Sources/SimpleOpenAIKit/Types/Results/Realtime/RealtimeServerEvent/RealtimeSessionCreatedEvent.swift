//
//  RealtimeSessionCreate.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/20/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct RealtimeSessionCreatedEvent {
    public static let type: String = "realtime.created"
    public let event_id: String
    public let session: RealtimeSession
}

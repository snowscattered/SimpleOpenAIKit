//
//  RealtimeResponseCreatedEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/20/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct RealtimeResponseCreatedEvent {
    public static let type: String = "response.created"
    public let event_id: String
    public let response: RealtimeResponse
}

//
//  BetaRealtimeResponseDoneEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeResponseDoneEvent {
    public static let type: String = "response.done"
    public let event_id: String
    public let response: BetaRealtimeResponse
}

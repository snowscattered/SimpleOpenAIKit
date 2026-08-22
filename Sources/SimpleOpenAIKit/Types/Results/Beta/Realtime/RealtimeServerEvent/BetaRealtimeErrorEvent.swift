//
//  BetaRealtimeErrorEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeErrorEvent {
    public static let type: String = "error"
    public let event_id: String
    public let error: BetaRealtimeError
}

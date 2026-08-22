//
//  BetaRealtimeResponseCancelEventParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeResponseCancelEventParameters {
    public static let type: String = "response.cancel"
    public var event_id: String?
    public var response_id: String?
}

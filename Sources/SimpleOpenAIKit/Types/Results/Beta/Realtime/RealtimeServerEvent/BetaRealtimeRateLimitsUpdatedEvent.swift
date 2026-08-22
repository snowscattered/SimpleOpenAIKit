//
//  BetaRealtimeRateLimitsUpdatedEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/20/26.
//

import Foundation
import SimpleCodableMacro

@CodableLiteral
public enum BetaRealtimeRateLimitName: String {
    case requests
    case tokens
}

@BaseModelNoWithExtra
public struct BetaRealtimeRateLimit {
    public let limit: Int?
    public let name: BetaRealtimeRateLimitName?
    public let remaining: Int?
    public let reset_seconds: Float?
}

@BaseModelNoWithExtra
public struct BetaRealtimeRateLimitsUpdatedEvent {
    public static let type: String = "rate_limits.updated"
    public let event_id: String
    public let rate_limits: [BetaRealtimeRateLimit]
}

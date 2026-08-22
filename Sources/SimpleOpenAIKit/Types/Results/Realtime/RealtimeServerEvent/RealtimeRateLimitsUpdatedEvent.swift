//
//  RealtimeRateLimitsUpdatedEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/20/26.
//

import Foundation
import SimpleCodableMacro

@CodableLiteral
public enum RealtimeRateLimitName: String {
    case requests
    case tokens
}

@BaseModelNoWithExtra
public struct RealtimeRateLimit {
    public let limit: Int?
    public let name: RealtimeRateLimitName?
    public let remaining: Int?
    public let reset_seconds: Float?
}

@BaseModelNoWithExtra
public struct RealtimeRateLimitsUpdatedEvent {
    public static let type: String = "rate_limits.updated"
    public let event_id: String
    public let rate_limits: [RealtimeRateLimit]
}

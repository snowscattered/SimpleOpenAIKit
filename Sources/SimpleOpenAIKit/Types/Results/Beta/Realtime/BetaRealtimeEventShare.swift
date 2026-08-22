//
//  BetaRealtimeEventShare.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

// MARK: Part
@CodableLiteral
public enum BetaRealtimeContentPartLiteral: String {
    case text, audio
}
@BaseModelNoWithExtra
public struct BetaRealtimePart {
    public let audio: String?
    public let text: String?
    public let transcript: String?
    public let type: BetaRealtimeContentPartLiteral?
}

// MARK: LogProbProperties
@BaseModelNoWithExtra
public struct BetaRealtimeLogProbProperties {
    public let token: String
    public let bytes: [Int]
    public let logprob: Double
}
// MARK: Usage
@BaseModelNoWithExtra
public struct BetaRealtimeUsageTranscriptTextUsageTokensInputTokenDetails {
    public let audio_tokens: Int?
    public let text_tokens: Int?
}
@BaseModelNoWithExtra
public struct BetaRealtimeUsageTranscriptTextUsageTokens {
    public static let type: String = "tokens"
    public let input_tokens: Int
    public let output_tokens: Int
    public let total_tokens: Int
    public let input_token_details: BetaRealtimeUsageTranscriptTextUsageTokensInputTokenDetails?
}
@BaseModelNoWithExtra
public struct BetaRealtimeUsageTranscriptTextUsageDuration {
    public static let type: String = "duration"
    public let seconds: Double
}
@CodableByConstant
public enum BetaRealtimeUsage: Codable {
    case tokens(BetaRealtimeUsageTranscriptTextUsageTokens)
    case duration(BetaRealtimeUsageTranscriptTextUsageDuration)
}
// MARK: Error
@BaseModelNoWithExtra
public struct BetaRealtimeError {
    public let event_id: String?
    public let code: String?
    public let message: String?
    public let param: String?
    public let type: String?
}
// MARK: Response
@CodableLiteral
public enum BetaRealtimeResponseStatus: String {
    case completed
    case cancelled
    case failed
    case incomplete
    case in_progress
}
@CodableLiteral
public enum BetaRealtimeResponseStatusReason: String {
    case turn_detected
    case client_cancelled
    case max_output_tokens
    case content_filter
}

@CodableLiteral
public enum BetaRealtimeResponseStatusType: String {
    case completed
    case cancelled
    case incomplete
    case failed
}
@BaseModelNoWithExtra
public struct BetaRealtimeResponseStatusDetails {
    public let error: BetaRealtimeError?
    public let reason: BetaRealtimeResponseStatusReason?
    public let type: BetaRealtimeResponseStatusType?
}
@BaseModelNoWithExtra
public struct BetaRealtimeResponseResult {
    public static let object: String = "realtime.response"
    public let id: String?
    public let conversation_id: String?
    public let max_output_tokens: Int?
    public let metadata: OpenAIMetaData?
    public let modalities: [BetaRealtimeModality]?
    public let output: [BetaRealtimeConversationItem]?
    public let output_audio_format: BetaRealtimeOutputAudioFormat?
    public let status: BetaRealtimeResponseStatus?
    public let status_details: BetaRealtimeResponseStatusDetails?
    public let temperature: Float?
    public let usage: BetaRealtimeUsage?
    public let voice: String?
}

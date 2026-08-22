//
//  RealtimeEventShare.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/20/26.
//

import Foundation
import SimpleCodableMacro

// MARK: Part
@CodableLiteral
public enum RealtimeContentPartLiteral: String {
    case text, audio
}
@BaseModelNoWithExtra
public struct RealtimePart {
    public let audio: String?
    public let text: String?
    public let transcript: String?
    public let type: RealtimeContentPartLiteral?
}

// MARK: LogProbProperties
@BaseModelNoWithExtra
public struct RealtimeLogProbProperties {
    public let token: String
    public let bytes: [Int]
    public let logprob: Double
}
// MARK: Usage
@BaseModelNoWithExtra
public struct RealtimeUsageTranscriptTextUsageTokensInputTokenDetails {
    public let audio_tokens: Int?
    public let text_tokens: Int?
}
@BaseModelNoWithExtra
public struct RealtimeUsageTranscriptTextUsageTokens {
    public static let type: String = "tokens"
    public let input_tokens: Int
    public let output_tokens: Int
    public let total_tokens: Int
    public let input_token_details: RealtimeUsageTranscriptTextUsageTokensInputTokenDetails?
}
@BaseModelNoWithExtra
public struct RealtimeUsageTranscriptTextUsageDuration {
    public static let type: String = "duration"
    public let seconds: Double
}
@CodableByConstant
public enum RealtimeUsage: Codable {
    case tokens(RealtimeUsageTranscriptTextUsageTokens)
    case duration(RealtimeUsageTranscriptTextUsageDuration)
}
// MARK: Error
@BaseModelNoWithExtra
public struct RealtimeError {
    public let event_id: String?
    public let code: String?
    public let message: String?
    public let param: String?
    public let type: String?
}

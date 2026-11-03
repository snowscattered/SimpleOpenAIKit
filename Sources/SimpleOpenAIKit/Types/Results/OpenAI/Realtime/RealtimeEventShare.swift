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
@PublicInit
public struct RealtimePart {
    public let audio: String?
    public let text: String?
    public let transcript: String?
    public let type: RealtimeContentPartLiteral?
}

// MARK: LogProbProperties
@BaseModelNoWithExtra
@PublicInit
public struct RealtimeLogProbProperties {
    public let token: String
    public let bytes: [Int]
    public let logprob: Double
}
// MARK: Usage
@BaseModelWithExtra
@PublicInit
public struct RealtimeTranscriptTextUsageTokensInputTokenDetails {
    public let audio_tokens: Int?
    public let text_tokens: Int?
}
@BaseModelWithExtra
@PublicInit
public struct RealtimeTranscriptTextUsageTokens {
    public static let type: String = "tokens"
    public let input_tokens: Int
    public let output_tokens: Int
    public let total_tokens: Int
    public let input_token_details: RealtimeTranscriptTextUsageTokensInputTokenDetails?
}
@BaseModelNoWithExtra
@PublicInit
public struct RealtimeTranscriptTextUsageDuration {
    public static let type: String = "duration"
    public let seconds: Double
}
@CodableByConstant
public enum RealtimeUsage: Codable {
    case tokens(RealtimeTranscriptTextUsageTokens)
    case duration(RealtimeTranscriptTextUsageDuration)
}
// MARK: Error
@BaseModelNoWithExtra
@PublicInit
public struct RealtimeError {
    public let event_id: String?
    public let code: String?
    public let message: String?
    public let param: String?
    public let type: String?
}

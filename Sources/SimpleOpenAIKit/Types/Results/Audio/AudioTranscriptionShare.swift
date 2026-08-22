//
//  AudioTranscriptionShare.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

// AudioTranscriptionCreateResult.AudioTranscription.Logprob
@BaseModelNoWithExtra
public struct AudioTranscriptionLogprob {
    public let token: String?
    public let bytes: [Int]?
    public let logprob: Float?
}

// AudioTranscriptionCreateResult.Usage
@BaseModelNoWithExtra
public struct AudioTranscriptionUsageInputTokenDetails {
    public let audio_tokens: Int?
    public let text_tokens: Int?
}
@BaseModelNoWithExtra
public struct AudioTranscriptionUsageTokens {
    public static let type: String = "tokens"
    public let input_tokens: Int?
    public let output_tokens: Int?
    public let total_tokens: Int?
    public let input_token_details: AudioTranscriptionUsageInputTokenDetails?
}
@BaseModelNoWithExtra
public struct AudioTranscriptionUsageDuration {
    public static let type: String = "duration"
    public let seconds: Float
}
@CodableByConstant(nilCase: "tokens", still: true)
public enum AudioTranscriptionUsage {
    case tokens(AudioTranscriptionUsageTokens)
    case duration(AudioTranscriptionUsageDuration)
}

//
//  AudioTranscriptionCreateResult.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

//
@BaseModelNoWithExtra
@PublicInit
public struct AudioTranscription {
    public let text: String
    public let logprobs: [AudioTranscriptionLogprob]?
    public let usage: AudioTranscriptionUsage?
}
//
@BaseModelNoWithExtra
@PublicInit
public struct AudioTranscriptionDiarizedSegment {
    public static let type: String = "transcript.text.segment"
    public let id: String
    public let end: Float
    public let speaker: String
    public let start: Float
    public let text: String
}
@BaseModelNoWithExtra
@PublicInit
public struct AudioTranscriptionDiarized {
    public static let task: String = "transcribe"
    public let duration: Float
    public let segments: [AudioTranscriptionDiarizedSegment]
    public let text: String
    public let usage: AudioTranscriptionUsage?
}

@BaseModelNoWithExtra
@PublicInit
public struct AudioTranscriptionSegment {
    public let id: Int
    public let avg_logprob: Float
    public let compression_ratio: Float
    public let end: Float
    public let no_speech_prob: Float
    public let seek: Int
    public let start: Float
    public let temperature: Float
    public let text: String
    public let tokens: [Int]
}
@BaseModelNoWithExtra
@PublicInit
public struct AudioTranscriptionWord {
    public let end: Float
    public let start: Float
    public let word: String
}
@BaseModelNoWithExtra
@PublicInit
public struct AudioTranscriptionVerbose {
    public let duration: Float
    public let language: String
    public let text: String
    public let segments: [AudioTranscriptionSegment]?
    public let words: [AudioTranscriptionWord]?
    public let usage: AudioTranscriptionUsageDuration?
}

@CodableTraversal
@nonexhaustive
public enum AudioTranscriptionCreateResult {
    case string(String)
    case transcription(AudioTranscription)
    case verbose(AudioTranscriptionVerbose)
    case diarized(AudioTranscriptionDiarized)
}

extension AudioTranscriptionCreateResult: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) { self = .string(value) }
}

//
//  AudioTranscriptionParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

// MARK: - Chunking Strategy

@BaseModelNoWithExtra
@PublicInit
public struct AudioTranscriptionChunkingStrategy {
    public static let type: String = "auto"
    public var prefix_padding_ms: Int?
    public var silence_duration_ms: Int?
    public var threshold: Double?
}

// MARK: - Audio Transcription Literals

@CodableLiteral
public enum AudioTranscriptionTimestampGranularity: String {
    case word, segment
}

@CodableLiteral
public enum AudioTranscriptionResponseFormat: String {
    case json, text, srt, verbose_json, vtt, diarized_json
}

@CodableLiteral
public enum AudioTranscriptionInclude: String {
    case logprobs
}

// MARK: - Audio Transcription Param Model

@BaseModelWithExtra(encodeExtra: false)
@PublicInit
public struct AudioTranscriptionParameters {
    public var model: String
    public var file: FileParameters
    public var prompt: String?
    public var language: String?
    public var stream: Bool?
    public var temperature: Double?
    public var response_format: AudioTranscriptionResponseFormat?
    public var chunking_strategy: AudioTranscriptionChunkingStrategy?
    public var include: [AudioTranscriptionInclude]?
    public var known_speaker_names: [String]?
    public var known_speaker_references: [String]?
    public var timestamp_granularities: [AudioTranscriptionTimestampGranularity]?
}

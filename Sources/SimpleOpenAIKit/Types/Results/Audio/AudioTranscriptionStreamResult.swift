//
//  AudioTranscriptionStreamResult.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

// TranscriptionTextSegmentEvent
@BaseModelNoWithExtra
public struct AudioTranscriptionTextSegmentEvent {
    public static let type: String = "transcript.text.segment"
    public let id: String
    public let end: Float
    public let speaker: String
    public let start: Float
    public let text: String
}
@BaseModelNoWithExtra
public struct AudioTranscriptionTextDeltaEvent {
    public static let type: String = "transcript.text.delta"
    public let delta: String
    public let logprobs: [AudioTranscriptionLogprob]?
    public let segment_id: String?
}
//
@BaseModelNoWithExtra
public struct AudioTranscriptionTextDoneEvent {
    public static let type: String = "transcript.text.done"
    public let text: String
    public let logprobs: [AudioTranscriptionLogprob]?
    public let usage: AudioTranscriptionUsageTokens?
}


@CodableByConstant
public enum AudioTranscriptionStreamResult {
    case segment(AudioTranscriptionTextSegmentEvent)
    case delta(AudioTranscriptionTextDeltaEvent)
    case done(AudioTranscriptionTextDoneEvent)
}

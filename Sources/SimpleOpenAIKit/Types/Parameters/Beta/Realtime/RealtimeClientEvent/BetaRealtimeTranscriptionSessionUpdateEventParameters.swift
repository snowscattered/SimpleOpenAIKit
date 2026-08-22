//
//  BetaRealtimeTranscriptionSessionUpdateEventParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeTranscriptionSession {
    public var client_secret: BetaRealtimeClientSecret?
    public var input_audio_format: BetaRealtimeInputAudioFormat?
    public var input_audio_noise_reduction: BetaRealtimeInputAudioNoiseReduction?
    public var input_audio_transcription: BetaRealtimeInputAudioTranscription?
    public var include: [String]?
    public var modalities: [BetaRealtimeModality]?
    public var turn_detection: BetaRealtimeTurnDetection?
}

// MARK: Main
@BaseModelNoWithExtra
public struct BetaRealtimeTranscriptionSessionUpdateEventParameters {
    public static let type: String = "transcription_session.update"
    public var event_id: String?
    public var session: BetaRealtimeTranscriptionSession
}

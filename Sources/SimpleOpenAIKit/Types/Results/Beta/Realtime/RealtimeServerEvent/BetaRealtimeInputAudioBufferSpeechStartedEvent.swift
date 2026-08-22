//
//  BetaRealtimeInputAudioBufferSpeechStartedEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeInputAudioBufferSpeechStartedEvent {
    public static let type: String = "input_audio_buffer.speech_started"
    public let event_id: String
    public let item_id: String
    public let audio_start_ms: Int
}

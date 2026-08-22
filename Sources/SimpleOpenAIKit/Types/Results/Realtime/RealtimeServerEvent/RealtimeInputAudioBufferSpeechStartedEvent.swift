//
//  RealtimeInputAudioBufferSpeechStartedEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/20/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct RealtimeInputAudioBufferSpeechStartedEvent {
    public static let type: String = "input_audio_buffer.speech_started"
    public let event_id: String
    public let item_id: String
    public let audio_start_ms: Int
}

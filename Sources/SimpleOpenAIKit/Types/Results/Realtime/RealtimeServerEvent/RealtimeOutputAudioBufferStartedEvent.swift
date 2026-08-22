//
//  RealtimeOutputAudioBufferStartedEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/20/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct RealtimeOutputAudioBufferStartedEvent {
    public static let type: String = "output_audio_buffer.started"
    public let event_id: String
    public let response_id: String
}

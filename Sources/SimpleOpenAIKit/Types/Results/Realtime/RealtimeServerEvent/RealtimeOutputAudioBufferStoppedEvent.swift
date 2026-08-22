//
//  RealtimeOutputAudioBufferStoppedEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/20/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct RealtimeOutputAudioBufferStoppedEvent {
    public static let type: String = "output_audio_buffer.stopped"
    public let event_id: String
    public let response_id: String
}

//
//  RealtimeOutputAudioBufferClearEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/14/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct RealtimeOutputAudioBufferClearEventParameters {
    public static let type: String = "output_audio_buffer.clear"
    public var event_id: String?
}

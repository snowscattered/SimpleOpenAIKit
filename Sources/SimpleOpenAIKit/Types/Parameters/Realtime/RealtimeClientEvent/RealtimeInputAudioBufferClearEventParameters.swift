//
//  RealtimeInputAudioBufferClearEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/14/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct RealtimeInputAudioBufferClearEventParameters {
    public static let type: String = "input_audio_buffer.clear"
    public var event_id: String?
}

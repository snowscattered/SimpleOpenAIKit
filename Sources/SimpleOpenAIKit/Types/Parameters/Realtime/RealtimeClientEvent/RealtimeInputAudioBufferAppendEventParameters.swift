//
//  RealtimeInputAudioBufferAppendEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/14/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct RealtimeInputAudioBufferAppendEventParameters {
    public static let type: String = "input_audio_buffer.append"
    public var event_id: String?
    public var audio: String
}

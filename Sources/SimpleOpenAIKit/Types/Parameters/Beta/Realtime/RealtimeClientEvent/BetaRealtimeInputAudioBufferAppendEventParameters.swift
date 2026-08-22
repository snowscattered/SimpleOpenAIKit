//
//  BetaRealtimeInputAudioBufferAppendEventParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeInputAudioBufferAppendEventParameters {
    public static let type: String = "input_audio_buffer.append"
    public var event_id: String?
    public var audio: String
}

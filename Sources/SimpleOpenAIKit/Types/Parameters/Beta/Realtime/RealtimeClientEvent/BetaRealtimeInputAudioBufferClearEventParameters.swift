//
//  BetaRealtimeInputAudioBufferClearEventParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeInputAudioBufferClearEventParameters {
    public static let type: String = "input_audio_buffer.clear"
    public var event_id: String?
}

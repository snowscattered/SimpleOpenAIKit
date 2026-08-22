//
//  BetaRealtimeOutputAudioBufferClearEventParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeOutputAudioBufferClearEventParameters {
    public static let type: String = "output_audio_buffer.clear"
    public var event_id: String?
}

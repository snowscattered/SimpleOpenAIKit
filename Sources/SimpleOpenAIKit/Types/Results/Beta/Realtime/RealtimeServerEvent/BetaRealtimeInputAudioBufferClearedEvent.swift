//
//  BetaRealtimeInputAudioBufferClearedEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeInputAudioBufferClearedEvent {
    public static let type: String = "input_audio_buffer.cleared"
    public let event_id: String
}

//
//  BetaRealtimeInputAudioBufferCommitEventParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeInputAudioBufferCommitEventParameters {
    public static let type: String = "input_audio_buffer.commit"
    public var event_id: String?
}

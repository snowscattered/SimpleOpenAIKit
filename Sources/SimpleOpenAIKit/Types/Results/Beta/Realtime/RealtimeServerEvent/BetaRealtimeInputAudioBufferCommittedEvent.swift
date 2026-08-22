//
//  BetaRealtimeInputAudioBufferCommittedEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeInputAudioBufferCommittedEvent {
    public static let type: String = "input_audio_buffer.committed"
    public let event_id: String
    public let item_id: String
    public let previous_item_id: String?
}

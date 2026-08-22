//
//  RealtimeInputAudioBufferCommittedEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/20/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct RealtimeInputAudioBufferCommittedEvent {
    public static let type: String = "input_audio_buffer.committed"
    public let event_id: String
    public let item_id: String
    public let previous_item_id: String?
}

//
//  RealtimeConversationItemInputAudioTranscriptionDeltaEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/20/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct RealtimeConversationItemInputAudioTranscriptionDeltaEvent {
    public static let type: String = "conversation.item.input_audio_transcription.delta"
    public let event_id: String
    public let item_id: String
    public let content_index: Int?
    public let delta: String?
    public let logprobs: [RealtimeLogProbProperties]?
}

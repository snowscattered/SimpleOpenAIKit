//
//  BetaRealtimeConversationItemInputAudioTranscriptionCompletedEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeConversationItemInputAudioTranscriptionCompletedEvent {
    public static let type: String = "conversation.item.input_audio_transcription.completed"
    public let content_index: Int
    public let event_id: String
    public let item_id: String
    public let transcript: String
    public let usage: BetaRealtimeUsage
    public let logprobs: [BetaRealtimeLogProbProperties]?
}

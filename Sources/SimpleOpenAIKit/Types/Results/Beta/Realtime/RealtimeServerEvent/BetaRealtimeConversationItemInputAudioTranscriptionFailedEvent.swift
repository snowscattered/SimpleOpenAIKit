//
//  BetaRealtimeConversationItemInputAudioTranscriptionFailedEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeConversationItemInputAudioTranscriptionFailedEvent {
    public static let type: String = "conversation.item.input_audio_transcription.failed"
    public let event_id: String
    public let item_id: String
    public let content_index: Int
    public let error: BetaRealtimeError
}

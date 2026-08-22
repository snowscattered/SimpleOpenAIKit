//
//  RealtimeResponseAudioTranscriptDeltaEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/20/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct RealtimeResponseAudioTranscriptDeltaEvent {
    public static let type: String = "response.output_audio_transcript.delta"
    public let event_id: String
    public let response_id: String
    public let item_id: String
    public let output_index: Int
    public let content_index: Int
    public let delta: String
}

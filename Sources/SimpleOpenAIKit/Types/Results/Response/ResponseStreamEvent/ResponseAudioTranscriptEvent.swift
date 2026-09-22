//
//  ResponseAudioTranscriptEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct ResponseAudioTranscriptDeltaEvent {
    public static let type: String = "response.audio.transcript.delta"
    public let delta: String
    public let sequence_number: Int
}
@BaseModelNoWithExtra
@PublicInit
public struct ResponseAudioTranscriptDoneEvent {
    public static let type: String = "response.audio.transcript.done"
    public let sequence_number: Int
}

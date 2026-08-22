//
//  ResponseAudioEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ResponseAudioDeltaEvent {
    public static let type: String = "response.audio.delta"
    public let delta: String
    public let sequence_number: Int
}
@BaseModelNoWithExtra
public struct ResponseAudioDoneEvent {
    public static let type: String = "response.audio.done"
    public let sequence_number: Int
}

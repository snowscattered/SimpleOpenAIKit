//
//  BetaRealtimeSessionUpdateEventParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/16/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeClientSecretExpiresAfter {
    public static let anchor: String = "created_at"
    public var seconds: Int?
}
@BaseModelNoWithExtra
public struct BetaRealtimeClientSecret {
    public var expires_after: BetaRealtimeClientSecretExpiresAfter?
}
@CodableLiteral
public enum BetaRealtimeInputAudioNoiseReductionLiteral: String {
    case near_field, far_field
}
@BaseModelNoWithExtra
public struct BetaRealtimeInputAudioNoiseReduction {
    public var type: BetaRealtimeInputAudioNoiseReductionLiteral?
}
@BaseModelNoWithExtra
public struct BetaRealtimeInputAudioTranscription {
    public var language: String?
    public var model: String?
    public var prompt: String?
}
@BaseModelNoWithExtra
public struct BetaReamtimeTracingTracingConfiguration {
    public var group_id: String?
    public var metadata: BaseType?
    public var workflow_name: String?
}
@CodableLiteral
public enum BetaReamtimeTracingLiteral: String {
    case auto
}
@CodableTraversal
public enum BetaReamtimeTracing {
    case auto(BetaReamtimeTracingLiteral)
    case config(BetaReamtimeTracingTracingConfiguration)
}
@CodableLiteral
public enum BetaRealtimeTurnDetectionType: String {
    case server_vad
    case semantic_vad
}
@CodableLiteral
public enum BetaRealtimeTurnDetectionEagerness: String {
    case low
    case medium
    case high
    case auto
}
@BaseModelNoWithExtra
public struct BetaRealtimeTurnDetection {
    public var type: BetaRealtimeTurnDetectionType?
    public var create_response: Bool?
    public var eagerness: BetaRealtimeTurnDetectionEagerness?
    public var interrupt_response: Bool?
    public var threshold: Float?
    public var prefix_padding_ms: Int?
    public var silence_duration_ms: Int?
}

@BaseModelWithExtra
public struct BetaRealtimeSession {
    public private(set) var id: String?
    public var model: String?
    public var client_secret: BetaRealtimeClientSecret?
    public var input_audio_format: BetaRealtimeInputAudioFormat?
    public var input_audio_noise_reduction: BetaRealtimeInputAudioNoiseReduction?
    public var input_audio_transcription: BetaRealtimeInputAudioTranscription?
    public var output_audio_format: BetaRealtimeOutputAudioFormat?
    public var instructions: String?
    public var max_response_output_tokens: Int?
    public var modalities: [BetaRealtimeModality]?
    public var speed: Double?
    public var temperature: Double?
    public var tool_choice: String?
    public var tools: BataRealtimeTool?
    public var tracing: BetaReamtimeTracing?
    public var turn_detection: BetaRealtimeTurnDetection?
    public var voice: String?
}
// MARK: Main
@BaseModelNoWithExtra
public struct BetaRealtimeSessionUpdateEventParameters {
    public static let type: String = "session.update"
    public var event_id: String?
    public var session: BetaRealtimeSession
}

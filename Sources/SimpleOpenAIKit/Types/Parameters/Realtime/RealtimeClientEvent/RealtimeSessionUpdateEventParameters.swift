//
//  RealtimeSessionUpdateEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/14/26.
//

import Foundation
import SimpleCodableMacro

// MARK: Input Config
@CodableLiteral
public enum RealtimeNoiseReductionLiteral: String {
    case near_field, far_field
}
@BaseModelNoWithExtra
public struct RealtimeNoiseReduction {
    public var type: RealtimeNoiseReductionLiteral?
}
@BaseModelNoWithExtra
public struct RealtimeAudioTranscription {
    public var model: String?
    public var language: String?
    public var prompt: String?
}
@BaseModelNoWithExtra
public struct RealtimeServerVad {
    public static let type: String = "server_vad"
    public var create_response: Bool?
    public var idle_timeout_ms: Int?
    public var interrupt_response: Bool?
    public var prefix_padding_ms: Int?
    public var silence_duration_ms: Int?
    public var threshold: Float?
}
@CodableLiteral
public enum RealtimeSemanticVadEagerness: String {
    case auto, low, medium, high
}
@BaseModelNoWithExtra
public struct RealtimeSemanticVad {
    public static let type: String = "semantic_vad"
    public var create_response: Bool?
    public var eagerness: RealtimeSemanticVadEagerness?
    public var interrupt_response: Bool?
}
@CodableByConstant
public enum RealtimeAudioInputTurnDetection {
    case server_vad(RealtimeServerVad)
    case semantic_vad(RealtimeSemanticVad)
}
@BaseModelWithExtra
public struct RealtimeInputAudioConfig {
    public var format: RealtimeAudioFormat?
    public var noise_reduction: RealtimeNoiseReduction?
    public var transcription: RealtimeAudioTranscription?
    public var turn_detection: RealtimeAudioInputTurnDetection?
}
// MARK: Output Config
@BaseModelNoWithExtra
public struct RealtimeOutputAudioConfig {
    public var format: RealtimeAudioFormat?
    public var speed: Float?
    public var voice: String?
}
// MARK: Audio Config
@BaseModelNoWithExtra
public struct RealtimeAudioConfig {
    public var input: RealtimeInputAudioConfig?
    public var output: RealtimeOutputAudioConfig?
}
@CodableLiteral
public enum RealtimeInclude: String {
    case logprobs = "item.input_audio_transcription.logprobs"
}
// MARK: Tracing
@BaseModelNoWithExtra
public struct RealtimeTracing{
    public var group_id: String?
    public var metadata: BaseType?
    public var workflow_name: String?
}
// MARK: Truncation
@CodableLiteral
public enum RealtimeTruncationLiteral: String {
    case auto, disable
}
@BaseModelNoWithExtra
public struct RealtimeTokenLimits {
    public var post_instructions: Int?
}
@BaseModelNoWithExtra
public struct RealtimeTruncationRetentionRatio {
    public static let type: String = "retention_ratio"
    public var retention_ratio: Double
    public var token_limits: RealtimeTokenLimits?
}
@CodableTraversal
public enum RealtimeTruncation {
    case literal(RealtimeTruncationLiteral)
    case retion_ratio(RealtimeTruncationRetentionRatio)
}
// MARK: Realtime
@BaseModelWithExtra
public struct RealtimeSessionCreateRequest {
    public static let type: String = "realtime"
    public var model: String?
    public var instructions: String?
    public var prompt: ResponsePrompt?
    public var output_modalities: [RealtimeModalites]?
    public var audio: RealtimeAudioConfig?
    public var tool_choice: RealtimeResponseToolChoice?
    public var tools: [RealtimeResponseTool]?
    public var max_output_tokens: Int?
    public var include: [RealtimeInclude]?
    public var tracing: RealtimeTracing?
    public var truncation: RealtimeTruncation?
}

// MARK: - RealtimeTranscription
@BaseModelNoWithExtra
public struct RealtimeTranscriptionSessionAudioInput {
    public var format: RealtimeAudioFormat?
    public var noise_reduction: RealtimeNoiseReduction?
    public var turn_detection: RealtimeAudioInputTurnDetection?
}
@BaseModelNoWithExtra
public struct RealtimeTranscriptionSessionAudio {
    public var input: RealtimeTranscriptionSessionAudioInput?
}
@BaseModelWithExtra
public struct RealtimeTranscriptionSessionCreateRequest {
    public static let type: String = "transcription"
    public var audio: RealtimeTranscriptionSessionAudio?
    public var include: [RealtimeInclude]?
}
@CodableByConstant
public enum RealtimeSession {
    case realtime(RealtimeSessionCreateRequest)
    case transcription(RealtimeTranscriptionSessionCreateRequest)
}
// MARK: Main
@BaseModelNoWithExtra
public struct RealtimeSessionUpdateEventParameters {
    public static let type: String = "session.update"
    public var event_id: String?
    public var session: RealtimeSession
}

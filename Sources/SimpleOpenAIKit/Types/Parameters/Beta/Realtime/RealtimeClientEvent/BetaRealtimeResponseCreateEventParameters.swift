//
//  BetaRealtimeResponseCreateEventParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BataRealtimeTool {
    public static let type: String = "function"
    public var description: String?
    public var name: String?
    public var parameters: BaseType?
}

@BaseModelNoWithExtra
public struct BetaRealtimeResponse : Sendable{
    public var conversation: String?
    public var input: [BetaRealtimeConversationItem]?
    public var instructions: String?
    public var max_response_output_tokens: Int?
    public var metadata: OpenAIMetaData?
    public var modalities: [BetaRealtimeModality]?
    public var output_audio_format: BetaRealtimeOutputAudioFormat?
    public var temperature: Double?
    public var tool_choice: String?
    public var tools: [BataRealtimeTool]?
    public var voice: String?
}
@BaseModelNoWithExtra
public struct BetaRealtimeResponseCreateEventParameters {
    public static let type: String = "response.create"
    public var event_id: String?
    public var response: BetaRealtimeResponse
}

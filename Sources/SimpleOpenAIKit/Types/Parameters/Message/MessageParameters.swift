//
//  MessageParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

// MARK: - Message Parameters

@BaseModelWithExtra
public struct MessageParameters {
    public var model: String
    public var system: MessageSystem?
    public var messages: [MessageMessages]
    public var stream: Bool?
    public var tools: [MessageTool]?
    public var max_tokens: Int
    public var tool_choice: MessageToolChoice?
    public var thinking: MessageThinking?
    public var top_k: Int?
    public var top_p: Double?
    public var temperature: Double?
    public var metadata: MessageMetadata?
    public var stop_sequences: [String]?
    public var cache_control: MessageCacheControlEphemeral?
    public var container: String?
    public var inference_geo: String?
    public var output_config: MessageOutputConfig?
    public var service_tier: String?
}

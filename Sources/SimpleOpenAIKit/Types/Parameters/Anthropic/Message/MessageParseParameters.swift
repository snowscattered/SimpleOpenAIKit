//
//  MessageParseParameters.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/10/7.
//

import Foundation
import SimpleCodableMacro

@PublicInit
public struct MessageParseParameters<T: SchemaProtocol> {
    public var model: String
    public var system: MessageSystem?
    public var messages: [MessageMessages]
    public var output_config: MessageOutputConfig?
    public var output_format: T.Type?
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
    public var service_tier: String?
}

extension MessageParseParameters {
    var createParameters: MessageParameters {
        .init(
            model: self.model,
            system: self.system,
            messages: self.messages,
            stream: self.stream,
            tools: self.tools,
            max_tokens: self.max_tokens,
            tool_choice: self.tool_choice,
            thinking: self.thinking,
            top_k: self.top_k,
            top_p: self.top_p,
            temperature: self.temperature,
            metadata: self.metadata,
            stop_sequences: self.stop_sequences,
            cache_control: self.cache_control,
            container: self.container,
            inference_geo: self.inference_geo,
            output_config: self.output_format.map {
                MessageOutputConfig(
                    effort: self.output_config?.effort,
                    format: MessageJSONOutputFormat($0)
                )
            } ?? self.output_config,
            service_tier: self.service_tier
        )
    }
}

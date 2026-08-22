//
//  MessageCountTokenParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelWithExtra
public struct MessageCountTokenParameters {
    public var model: String
    public var system: MessageSystem?
    public var messages: [MessageMessages]
    public var thinking: MessageThinking?
    public var tools: [MessageTool]?
    public var tool_choice: MessageToolChoice?
    public var cache_control: MessageCacheControlEphemeral?
    public var output_format: MessageJSONOutputFormat?
    public var output_config: MessageOutputConfig?
}

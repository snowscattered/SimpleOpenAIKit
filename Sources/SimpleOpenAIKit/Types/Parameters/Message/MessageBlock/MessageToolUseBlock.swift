//
//  MessageToolUseBlock.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct MessageToolUseBlock {
    public static let type: String = "tool_use"
    public var id: String
    public var name: String
    public var input: [String: BaseType]
    public var cache_control: MessageCacheControlEphemeral?
}

//
//  ChatToolMessageTypes.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ChatToolMessage {
    public static let role: String = "tool"
    public var tool_call_id: String
    public var content: ChatStringOrContentPartText
}

//
//  ChatSystemMessageTypes.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ChatSystemMessage {
    public static let role: String = "system"
    public var content: ChatStringOrContentPartText
    public var name: String?
}
extension ChatSystemMessage: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) { self = .init(content: .string(value)) }
}

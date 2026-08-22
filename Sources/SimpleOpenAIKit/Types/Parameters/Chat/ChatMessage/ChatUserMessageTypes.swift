//
//  ChatUserMessageTypes.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@SingleOrArray
public enum ChatStringOrContentPart {
    case string(String)
    case array([ChatContentPart])
}
extension ChatStringOrContentPart: ExpressibleByStringLiteral, ExpressibleByArrayLiteral {
    public init(stringLiteral value: String)               { self = .string(value) }
    public init(arrayLiteral elements: ChatContentPart...) { self = .array(elements) }
}

@BaseModelNoWithExtra
public struct ChatUserMessage {
    public static let role: String = "user"
    public var content: ChatStringOrContentPart
    public var name: String?
}
extension ChatUserMessage: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) { self = .init(content: .string(value)) }
}

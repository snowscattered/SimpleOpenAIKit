//
//  ResopnseAgentMessageItem.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/6/26.
//

import Foundation
import SimpleCodableMacro

@CodableByConstant
public enum ResponseAgentMessageContent {
    case input_text(ResponseTextContent)
    case input_image(ResponseImageContent)
    case input_file(ResponseFileContent)
    case encrypted_content(ResponseEncryptedContent)
}
@SingleOrArray
public enum ResponseAgentMessageItemContent {
    case string(String)
    case array([ResponseAgentMessageContent])
}
extension ResponseAgentMessageItemContent: ExpressibleByStringLiteral, ExpressibleByArrayLiteral {
    public init(stringLiteral value: String)                           { self = .string(value) }
    public init(arrayLiteral elements: ResponseAgentMessageContent...) { self = .array(elements) }
}

// Codex Agent
@BaseModelNoWithExtra
public struct ResopnseAgentMessageItem {
    public static let type: String = "agent_message"
    public var id: String?
    public var author: String?
    public var recipient: String?
    public var content: [ ResponseAgentMessageContent ]
    public var status: ResponseItemStatusLiteral?
}
extension ResopnseAgentMessageItem {
    public func toInputMessage() -> ResponseMessage {
        var content = [] as [ ResponseMessageInputContent ]
        for i in self.content {
            switch i {
            case .encrypted_content(let c):
                content.append(.input_text(.init(text: c.encrypted_content)))
            default: continue
            }
        }
        return .init(role: .user, content: content, status: self.status)
    }
}

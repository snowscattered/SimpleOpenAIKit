//
//  ResponseMessageItem.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ResponseTopLogprob {
    public var token: String
    public var bytes: [Int]
    public var logprob: Float
}
@BaseModelNoWithExtra
public struct ResponseLogprob {
    public var token: String
    public var bytes: [Int]
    public var logprob: Float
    public var top_logprobs: [ResponseTopLogprob]
}
@BaseModelNoWithExtra
public struct ResponseOutputText: Sendable {
    public static let type: String = "output_text"
    public var text: String
    public var logprobs: [ResponseLogprob]?
    public var annotations: [ResponseAnnotation]?
}
@BaseModelNoWithExtra
public struct ResponseOutputRefusal {
    public static let type: String = "refusal"
    public var refusal: String
}
@CodableLiteral
public enum ResponsePhaseLiteral: String {
    case commentary
    case final_answer
}
// MARK: - EasyInputMessage
public typealias ResponseMessageInputContent = ResponseContent

@SingleOrArray
public enum ResponseMessageInputItemContent {
    case string(String)
    case array([ResponseMessageInputContent])
}
extension ResponseMessageInputItemContent: ExpressibleByStringLiteral, ExpressibleByArrayLiteral {
    public init(stringLiteral value: String)                           { self = .string(value) }
    public init(arrayLiteral elements: ResponseMessageInputContent...) { self = .array(elements) }
}
@CodableLiteral
public enum ResponseEasyInputMessageRoleLiteral: String {
    case user, assistant, system, developer
}
// MARK: - Message
@CodableLiteral
public enum ResponseMessageRoleLiteral: String {
    case user, system, developer
}
// MARK: - OutputMessage
@CodableByConstant
public enum ResponseOutputMessageContent {
    case output_text(ResponseOutputText)
    case refusal(ResponseOutputRefusal)
}
// MARK: - MessageItem
@BaseModelNoWithExtra
public struct ResponseEasyInputMessage {
    public static let type: String = "message"
    public var role: ResponseEasyInputMessageRoleLiteral
    public var content: ResponseMessageInputItemContent
    public var phase: ResponsePhaseLiteral?
}
@BaseModelNoWithExtra
public struct ResponseMessage {
    public static let type: String = "message"
    public var role: ResponseMessageRoleLiteral // No Assistant
    public var content: [ResponseMessageInputContent]
    public var status: ResponseItemStatusLiteral?
}
@BaseModelNoWithExtra
public struct ResponseOutputMessage {
    public static let type: String = "message"
    public static let role: String = "assistant"
    public var id: String
    public var content: [ResponseOutputMessageContent]
    public var status: ResponseItemStatusLiteral?
    public var phase: ResponsePhaseLiteral?
}
// MARK: - MessageItem
public enum ResponseMessageItem {
    public static let type: String = "message"
    case EasyInputMessage(ResponseEasyInputMessage)
    case Message(ResponseMessage)
    case OutputMessage(ResponseOutputMessage)
}
// Customized
nonisolated extension ResponseMessageItem: BaseModel {
    enum CodingKeys: String, CodingKey {
        case type
        case status
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let hasStatus = container.contains(.status)
        
        if hasStatus {
            if let value = try? ResponseOutputMessage(from: decoder) {
                self = .OutputMessage(value)
            } else {
                self = .Message(try ResponseMessage(from: decoder))
            }
        } else {
            if let value = try? ResponseEasyInputMessage(from: decoder) {
                self = .EasyInputMessage(value)
            } else {
                self = .Message(try ResponseMessage(from: decoder))
            }
        }
    }
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .EasyInputMessage(let msg):
            try msg.encode(to: encoder)
        case .Message(let msg):
            try msg.encode(to: encoder)
        case .OutputMessage(let msg):
            try msg.encode(to: encoder)
        }
    }
}

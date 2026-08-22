//
//  ResponseContentPartEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro


//@BaseModelNoWithExtra
//public struct ResponseReasoningTextPart {
//    public static let type: String = "reasoning_text"
//    public let text: String
//}
public typealias ResponseReasoningTextPart = ResponseReasoningContent
@CodableByConstant
public enum ResponseContentPart {
    case reasoning_text(ResponseReasoningTextPart)
    case output_text(ResponseOutputText)
    case refusal(ResponseOutputRefusal)
}
@BaseModelNoWithExtra
public struct ResponseContentPartAddedEvent {
    public static let type: String = "response.content_part.added"
    public let content_index: Int
    public let item_id: String
    public let output_index: Int
    public let part: ResponseContentPart
    public let sequence_number: Int
}
@BaseModelNoWithExtra
public struct ResponseContentPartDoneEvent {
    public static let type: String = "response.content_part.done"
    public let content_index: Int
    public let item_id: String
    public let output_index: Int
    public let part: ResponseContentPart
    public let sequence_number: Int
}

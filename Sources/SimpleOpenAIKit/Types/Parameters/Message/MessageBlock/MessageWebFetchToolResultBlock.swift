//
//  MessageWebFetchToolResultBlock.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/27/26.
//

import Foundation
import SimpleCodableMacro

@CodableLiteral
public enum WebFetchToolResultErrorCode: String {
    case invalid_tool_input
    case url_too_long
    case url_not_allowed
    case url_not_accessible
    case unsupported_content_type
    case too_many_requests
    case max_uses_exceeded
    case unavailable
}
@BaseModelNoWithExtra
public struct WebFetchToolResultErrorBlock {
    public static let type: String = "web_fetch_tool_result_error"
    public var error_code: WebFetchToolResultErrorCode
}
@BaseModelNoWithExtra
public struct WebFetchBlock {
    public static let type: String = "web_fetch_result"
    public var content: MessageDocumentBlock
    public var url: String
    public var retrieved_at: String?
}
@CodableByConstant
public enum WebFetchResultContent {
    case block(WebFetchBlock)
    case error(WebFetchToolResultErrorBlock)
}
@BaseModelNoWithExtra
public struct MessageWebFetchToolResultBlock {
    public static let type: String = "web_fetch_tool_result"
    public var content: WebFetchResultContent
    public var tool_use_id: String
    public var cache_control: MessageCacheControlEphemeral?
    public var caller: MessageCaller?
}

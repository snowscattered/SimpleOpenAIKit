//
//  MessageWebSearchToolResultBlock.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/27/26.
//

import Foundation
import SimpleCodableMacro

@CodableLiteral
public enum WebSearchToolResultErrorCode: String {
    case invalid_tool_input
    case unavailable
    case max_uses_exceeded
    case too_many_requests
    case query_too_long
    case request_too_large
}
@BaseModelNoWithExtra
public struct WebSearchToolRequestErrorBlock {
    public static let type: String = "web_search_tool_result_error"
    public var error_code: WebSearchToolResultErrorCode
}
@BaseModelNoWithExtra
public struct WebSearchBlock {
    public static let type: String = "web_search_result"
    public var url: String
    public var title: String
    public var encrypted_content: String
    public var page_age: String?
}
@CodableTraversal
public enum WebSearchResultContent {
    case blocks([WebSearchBlock])
    case error(WebSearchToolRequestErrorBlock)
}
@BaseModelNoWithExtra
public struct MessageWebSearchToolResultBlock {
    public static let type: String = "web_search_tool_result"
    public var content: WebSearchResultContent
    public var tool_use_id: String
    public var cache_control: MessageCacheControlEphemeral?
    public var caller: MessageCaller?
}

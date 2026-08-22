//
//  MessageWebFetchTool.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/5/26.
//

import Foundation
import SimpleCodableMacro


@CodableLiteral
public enum MessageWebFetchToolTypeLiteral: String {
    case web_fetch_20250910
    case web_fetch_20260209
}

@CodableLiteral
public enum MessageWebFetchType: String {
    case web_fetch
}

@BaseModelNoWithExtra
public struct MessageWebFetchTool {
    public var name: MessageWebFetchType
    public var type: MessageWebFetchToolTypeLiteral
    
    public var allowed_callers: [MessageAllowedCaller]?
    public var allowed_domains: [String]?
    public var blocked_domains: [String]?
    public var cache_control: MessageCacheControlEphemeral?
    public var citations: MessageCitationsConfig?
    public var defer_loading: Bool?
    public var max_content_tokens: Int?
    public var max_uses: Int?
    public var strict: Bool?
}

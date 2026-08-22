//
//  MessageWebSearchTool.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/5/26.
//

import Foundation
import SimpleCodableMacro

@CodableLiteral
public enum MessageWebSearchToolTypeLiteral: String {
    case web_search_20250305
    case web_search_20260209
}

@CodableLiteral
public enum MessageWebSearchType: String {
    case web_search
}

@BaseModelNoWithExtra
public struct MessageWebSearchTool {
    public var name: MessageWebSearchType
    public var type: MessageWebSearchToolTypeLiteral
    
    public var allowed_callers: [MessageAllowedCaller]?
    public var allowed_domains: [String]?
    public var blocked_domains: [String]?
    public var cache_control: MessageCacheControlEphemeral?
    public var defer_loading: Bool?
    public var max_uses: Int?
    public var strict: Bool?
    public var user_location: MessageUserLocation?
}

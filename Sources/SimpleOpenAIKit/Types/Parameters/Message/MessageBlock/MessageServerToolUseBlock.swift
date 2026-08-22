//
//  MessageServerToolUseBlock.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/1/26.
//

import Foundation
import SimpleCodableMacro

// 定义 name 枚举
@CodableLiteral
public enum ServerToolUseName: String {
    case web_search
    case web_fetch
    case code_execution
    case bash_code_execution
    case text_editor_code_execution
    case tool_search_tool_regex
    case tool_search_tool_bm25
}

@BaseModelNoWithExtra
public struct MessageServerToolUseBlock {
    public static let type: String = "server_tool_use"
    public var id: String
    public var caller: MessageCaller?
    public var input: [String: BaseType]
    public var name: ServerToolUseName
    public var cache_control: MessageCacheCreation?
}

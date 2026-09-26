//
//  MessageTool.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/5/26.
//

import Foundation
import SimpleCodableMacro

@CodableByConstant(nilCase: "tool", still: true)
@nonexhaustive
public enum MessageTool {
    @MultiConstant("custom")
    case tool(MessageBaseTool)
    @MultiConstant(["web_search_20250305", "web_search_20260209"])
    case web_search(MessageWebSearchTool)
    @MultiConstant(["web_fetch_20250910", "web_fetch_20260209"])
    case web_fetch(MessageWebFetchTool)
}
extension MessageTool {
    public static var web_search: MessageTool {
        return .web_search(.init(name: .web_search, type: .web_search_20260209, max_uses: 5))
    }
}

//public typealias MessageTool = MessageBaseTool

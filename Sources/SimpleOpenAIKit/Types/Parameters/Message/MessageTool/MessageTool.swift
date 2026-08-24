//
//  MessageTool.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/5/26.
//

import Foundation
import SimpleCodableMacro

@CodableTraversal
@nonexhaustive
public enum MessageTool {
    case tool(MessageBaseTool)
    case web_search(MessageWebSearchTool)
    case web_fetch(MessageWebFetchTool)
}
extension MessageTool {
    public static var web_search: MessageTool {
        return .web_search(.init(name: .web_search, type: .web_search_20260209, max_uses: 5))
    }
}

//public typealias MessageTool = MessageBaseTool

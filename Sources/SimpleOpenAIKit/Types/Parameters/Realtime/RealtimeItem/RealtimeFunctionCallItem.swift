//
//  RealtimeConversationItemFunctionCall.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/14/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct RealtimeFunctionCallItem {
    public static let object: String = "realtime.item"
    public static let type: String = "function_call"
    public var id: String?
    public var call_id: String?
    public var name: String
    public var arguments: String
    public var status: RealtimeItemStatus?
}

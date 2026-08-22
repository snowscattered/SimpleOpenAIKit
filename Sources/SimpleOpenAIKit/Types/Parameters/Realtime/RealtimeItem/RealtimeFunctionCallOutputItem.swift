//
//  RealtimeConversationItemFunctionCallOutput.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/14/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct RealtimeFunctionCallOutputItem {
    public static let object: String = "realtime.item"
    public static let type: String = "function_call_output"
    public var id: String?
    public var call_id: String
    public var output: String
    public var status: RealtimeItemStatus?
}

//
//  BetaRealtimeConversationItem.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@CodableLiteral
public enum BetaRealtimeContentLiteral: String {
    case input_text
    case input_audio
    case item_reference
    case text
    case audio
}
@CodableLiteral
public enum BetaRealtimeConversationItemLiteral: String {
    case message
    case function_call
    case function_call_output
    case item_reference
}
@CodableLiteral
public enum BetaRealtimeRole: String {
    case system, user, assistant
}
@CodableLiteral
public enum BetaRealtimeItemStatus: String {
    case completed, incomplete, in_progress
}

@BaseModelNoWithExtra
public struct BetaRealtimeContent {
    public var id: String?
    public var audio: String?
    public var text: String?
    public var transcript: String?
    public var type: BetaRealtimeContentLiteral?
}

@BaseModelNoWithExtra
public struct BetaRealtimeConversationItem {
    public static let object: String = "realtime.item"
    public var type: BetaRealtimeConversationItemLiteral?
    public var id: String?
    public var content: [BetaRealtimeContent]?
    public var call_id: String?
    public var name: String?
    public var arguments: String?
    public var output: String?
    public var role: BetaRealtimeRole?
    public var status: BetaRealtimeItemStatus?
}

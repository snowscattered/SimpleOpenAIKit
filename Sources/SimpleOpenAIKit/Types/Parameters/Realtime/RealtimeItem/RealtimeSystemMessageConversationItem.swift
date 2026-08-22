//
//  RealtimeConversationItemSystemMessage.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/14/26.
//

import Foundation
import SimpleCodableMacro

@CodableLiteral
public enum RealtimeSystemContentType: String {
    case input_text
}
@BaseModelNoWithExtra
public struct RealtimeSystemContent {
    public var text: String?
    public var type: RealtimeSystemContentType?
}

@BaseModelWithExtra
public struct RealtimeSystemMessageConversationItem {
    public static let object: String = "realtime.item"
    public static let role: String = "system"
    public static let type: String = "message"
    public var id: String?
    public var content: [RealtimeSystemContent]
    public var status: RealtimeItemStatus?
}

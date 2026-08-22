//
//  RealtimeConversationItemAssistantMessage.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/14/26.
//

import Foundation
import SimpleCodableMacro

@CodableLiteral
public enum RealtimeAssistantContentType: String {
    case output_text, output_audio
}

@BaseModelNoWithExtra
public struct RealtimeAssistantContent {
    public var audio: String?
    public var text: String?
    public var transcript: String?
    public var type: RealtimeAssistantContentType?
}

@BaseModelNoWithExtra
public struct RealtimeAssistantMessageConversationItem {
    public static let object: String = "realtime.item"
    public static let role: String = "assistant"
    public static let type: String = "message"
    public var id: String?
    public var content: [RealtimeAssistantContent]
    public var status: RealtimeItemStatus?
}

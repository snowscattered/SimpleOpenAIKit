//
//  RealtimeConversationItemUserMessage.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/14/26.
//

import Foundation
import SimpleCodableMacro

@CodableLiteral
public enum RealtimeUserContentImageDetail: String {
    case auto, low, high
}

@CodableLiteral
public enum RealtimeUserContentType: String {
    case input_text, input_audio, input_image
}

@BaseModelNoWithExtra
public struct RealtimeUserContent {
    public var type: RealtimeUserContentType?
    public var audio: String?
    public var transcript: String?
    public var image_url: String?
    public var detail: RealtimeUserContentImageDetail?
    public var text: String?
}

@BaseModelNoWithExtra
public struct RealtimeUserMessageConversationItem {
    public static let object: String = "realtime.item"
    public static let role: String = "user"
    public static let type: String = "message"
    public var id: String?
    public var content: [RealtimeUserContent]
    public var status: RealtimeItemStatus?
}

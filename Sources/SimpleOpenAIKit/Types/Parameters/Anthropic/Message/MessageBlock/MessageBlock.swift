//
//  MessageBlock.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

// MARK: - Block Union

@CodableByConstant
@nonexhaustive
public enum MessageBlock {
    case text(MessageTextBlock)
    case thinking(MessageThinkingBlock)
    case image(MessageImageBlock)
    case video(MessageVideoBlock)  // Extension Anthropic
    case document(MessageDocumentBlock)
    
    case tool_use(MessageToolUseBlock)
    case tool_result(MessageToolResultBlock)
    case search_result(MessageSearchResultBlock)
    case server_tool_use(MessageServerToolUseBlock)
    case web_search_result(MessageWebSearchToolResultBlock)
    case web_fetch_result(MessageWebFetchToolResultBlock)
}

public extension MessageBlock {
    static func text(_ text: String) -> Self {
        .text(MessageTextBlock(text: text))
    }
    static func thinking(_ text: String) -> Self {
        .thinking(MessageThinkingBlock(thinking: text))
    }
    static func image(_ data: String, miniType: MessageBase64ImageSourceMidiaType) -> Self {
        .image(MessageImageBlock(source: .base64(.init(data: data, media_type: miniType))))
    }
    static func image(_ url: String) -> Self {
        .image(MessageImageBlock(source: .url(.init(url: url))))
    }
    static func video(_ url: String) -> Self {
        .video(MessageVideoBlock(source: .url(.init(url: url))))
    }
    static func file(_ file_id: String) -> Self {
        .document(MessageDocumentBlock(source: .file(.init(file_id: file_id))))
    }
    // ...
}

//
//  MessageParseResult.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/10/7.
//

import Foundation

public struct MessageParseTextBlock<T> {
    public static var type: String { "text" }
    public let text: String
    public let cache_control: MessageCacheControlEphemeral?
    public let citations: [MessageCitation]?
    /// Result Field
    public let parsed: T?
}

public enum MessageParseBlock<T> {
    case text(MessageParseTextBlock<T>)
    case thinking(MessageThinkingBlock)
    case image(MessageImageBlock)
    case video(MessageVideoBlock)
    case document(MessageDocumentBlock)
    case tool_use(MessageToolUseBlock)
    case tool_result(MessageToolResultBlock)
    case search_result(MessageSearchResultBlock)
    case server_tool_use(MessageServerToolUseBlock)
    case web_search_result(MessageWebSearchToolResultBlock)
    case web_fetch_result(MessageWebFetchToolResultBlock)
}

extension MessageParseBlock {
    public var messageBlock: MessageBlock {
        switch self {
        case .text(let block):              return .text(block.textBlock)
        case .thinking(let block):          return .thinking(block)
        case .image(let block):             return .image(block)
        case .video(let block):             return .video(block)
        case .document(let block):          return .document(block)
        case .tool_use(let block):          return .tool_use(block)
        case .tool_result(let block):       return .tool_result(block)
        case .search_result(let block):     return .search_result(block)
        case .server_tool_use(let block):   return .server_tool_use(block)
        case .web_search_result(let block): return .web_search_result(block)
        case .web_fetch_result(let block):  return .web_fetch_result(block)
        }
    }
}

public struct MessageParseResult<T> {
    public static var role: String { "assistant" }
    public static var type: String { "message" }
    public let id: String
    public let container: MessageContainer?
    public let content: [MessageParseBlock<T>]
    public let model: String
    public let stop_details: MessageRefusalStopDetails?
    public let stop_reason: MessageStopReason?
    public let stop_sequence: String?
    public let usage: MessageUsage
}

extension MessageParseTextBlock {
    var textBlock: MessageTextBlock {
        .init(
            text: self.text,
            cache_control: self.cache_control,
            citations: self.citations
        )
    }
}

public extension Array where Element == MessageMessages {
    static func + <T>(lhs: [MessageMessages], rhs: MessageParseResult<T>) -> [MessageMessages] {
        lhs + [.assistant(.array(rhs.content.map { $0.messageBlock }))]
    }
}

// MARK: - From MessageCreateResult
extension MessageParseTextBlock where T: Decodable {
    init(_ block: MessageTextBlock) throws {
        let parsed = block.text.isEmpty ? nil : try JSONDecoder().decode(T.self, from: Data(block.text.utf8))
        self.init(
            text: block.text,
            cache_control: block.cache_control,
            citations: block.citations,
            parsed: parsed
        )
    }
}

extension MessageParseBlock where T: Decodable {
    init(_ block: MessageBlock) throws {
        switch block {
        case .text(let text):
            self = .text(try MessageParseTextBlock(text))
        case .thinking(let thinking):
            self = .thinking(thinking)
        case .image(let image):
            self = .image(image)
        case .video(let video):
            self = .video(video)
        case .document(let document):
            self = .document(document)
        case .tool_use(let toolUse):
            self = .tool_use(toolUse)
        case .tool_result(let toolResult):
            self = .tool_result(toolResult)
        case .search_result(let searchResult):
            self = .search_result(searchResult)
        case .server_tool_use(let serverToolUse):
            self = .server_tool_use(serverToolUse)
        case .web_search_result(let webSearchResult):
            self = .web_search_result(webSearchResult)
        case .web_fetch_result(let webFetchResult):
            self = .web_fetch_result(webFetchResult)
        }
    }
}

extension MessageParseResult where T: Decodable {
    init(_ result: MessageCreateResult) throws {
        self.init(
            id: result.id,
            container: result.container,
            content: try result.content.map { try MessageParseBlock($0) },
            model: result.model,
            stop_details: result.stop_details,
            stop_reason: result.stop_reason,
            stop_sequence: result.stop_sequence,
            usage: result.usage
        )
    }
}

//
//  ResponseWebSearchItem.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/13/26.
//

import Foundation
import SimpleCodableMacro

// MARK: - ActionSearchSource
@BaseModelNoWithExtra
public struct WebSearchActionSearchSource {
    public static let type: String = "url"
    public var url: String
}
@BaseModelNoWithExtra
public struct WebSearchActionSearch {
    public static let type: String = "search"
    public var query: String
    public var queries: [String]?
    public var sources: [WebSearchActionSearchSource]?
}
@BaseModelNoWithExtra
public struct WebSearchActionOpenPage {
    public static let type: String = "open_page"
    public var url: String?
}
@BaseModelNoWithExtra
public struct WebSearchActionFind {
    public static let type: String = "find_in_page"
    public var pattern: String
    public var url: String
}
@CodableByConstant
public enum WebSearchAction {
    case search(WebSearchActionSearch)
    case open_page(WebSearchActionOpenPage)
    case find(WebSearchActionFind)
}
@CodableLiteral
public enum WebSearchStatus: String {
    case in_progress
    case searching
    case completed
    case failed
}

// MARK: - ResponseFunctionWebSearchParam
@BaseModelNoWithExtra
public struct ResponseWebSearchItem {
    public static let type: String = "web_search_call"
    public var id: String
    public var action: WebSearchAction
    public var status: WebSearchStatus
}

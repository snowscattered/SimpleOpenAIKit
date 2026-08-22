//
//  MessageSearchResultBlock.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct MessageSearchResultBlock {
    public static let type: String = "search_result"
    public var content: [MessageTextBlock]
    public var source: String
    public var title: String
    public var cache_control: MessageCacheControlEphemeral?
    public var citations: MessageCitation?
}

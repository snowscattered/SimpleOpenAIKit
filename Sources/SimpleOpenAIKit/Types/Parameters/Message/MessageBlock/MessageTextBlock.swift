//
//  MessageTextBlock.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct MessageTextBlock {
    public static let type: String = "text"
    public var text: String
    public var cache_control: MessageCacheControlEphemeral?
    public var citations: [MessageCitation]?
}

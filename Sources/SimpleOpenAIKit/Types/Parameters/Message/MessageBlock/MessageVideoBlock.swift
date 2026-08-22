//
//  MessageVideoBlock.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

/// Extension Anthropic API
@BaseModelNoWithExtra
public struct MessageVideoBlock {
    public static let type: String = "video"
    public var source: MessageSource
    public var cache_control: MessageCacheControlEphemeral?
}

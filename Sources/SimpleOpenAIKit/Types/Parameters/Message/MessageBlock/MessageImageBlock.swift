//
//  MessageImageBlock.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct MessageImageBlock {
    public static let type: String = "image"
    public var source: MessageSource
    public var cache_control: MessageCacheControlEphemeral?
}

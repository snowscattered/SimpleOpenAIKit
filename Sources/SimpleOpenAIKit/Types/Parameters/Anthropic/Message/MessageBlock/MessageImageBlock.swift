//
//  MessageImageBlock.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@CodableLiteral
public enum MessageImageTransformationsOversizedImage: String {
    case downsize, error
}

@BaseModelNoWithExtra
@PublicInit
public struct MessageImageTransformations {
    public var oversized_image: MessageImageTransformationsOversizedImage
}

@BaseModelNoWithExtra
@PublicInit
public struct MessageImageBlock {
    public static let type: String = "image"
    public var source: MessageSource
    public var cache_control: MessageCacheControlEphemeral?
    public var transformations: MessageImageTransformations?
}

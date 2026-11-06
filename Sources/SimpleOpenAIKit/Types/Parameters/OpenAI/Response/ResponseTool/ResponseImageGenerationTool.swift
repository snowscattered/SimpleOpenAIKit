//
//  ResponseImageGenerationTool.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@CodableLiteral
public enum ResponseImageGenBackground: String {
    case transparent, opaque, auto
}

@CodableLiteral
public enum ResponseImageGenInputFidelity: String {
    case high, low
}

@CodableLiteral
public enum ResponseImageGenModeration: String {
    case auto, low
}

@CodableLiteral
public enum ResponseImageGenOutputFormat: String {
    case png, webp, jpeg
}

@CodableLiteral
public enum ResponseImageGenQuality: String {
    case low, medium, high, auto
}

@BaseModelNoWithExtra
@PublicInit
public struct ResponseImageGenerationInputImageMask {
    public var file_id: String
    public var image_url: String
}
@CodableLiteral
public enum ResponseImageGenerationToolAction: String {
    case generate, edit, auto
}

@BaseModelNoWithExtra
@PublicInit
public struct ResponseImageGenerationTool {
    public static let type: String = "image_generation"
    public var model: String?
    public var size: String?
    public var action: ResponseImageGenerationToolAction?
    public var background: ResponseImageGenBackground?
    public var input_fidelity: ResponseImageGenInputFidelity?
    public var input_image_mask: ResponseImageGenerationInputImageMask?
    public var moderation: ResponseImageGenModeration?
    public var output_compression: Int?
    public var output_format: ResponseImageGenOutputFormat?
    public var partial_images: Int?
    public var quality: ResponseImageGenQuality?
}

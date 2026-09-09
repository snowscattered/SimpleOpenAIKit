//
//  ResponseImageGenerationTool.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@CodableLiteral
public enum ResponseImageGenBackgroundLiteral: String {
    case transparent, opaque, auto
}

@CodableLiteral
public enum ResponseImageGenInputFidelityLiteral: String {
    case high, low
}

@CodableLiteral
public enum ResponseImageGenModerationLiteral: String {
    case auto, low
}

@CodableLiteral
public enum ResponseImageGenOutputFormatLiteral: String {
    case png, webp, jpeg
}

@CodableLiteral
public enum ResponseImageGenQualityLiteral: String {
    case low, medium, high, auto
}

@BaseModelNoWithExtra
public struct ResponseImageGenerationInputImageMask {
    public var file_id: String
    public var image_url: String
}
@CodableLiteral
public enum ResponseImageGenerationToolAction: String {
    case generate, edit, auto
}

@BaseModelNoWithExtra
public struct ResponseImageGenerationTool {
    public static let type: String = "image_generation"
    public var model: String?
    public var size: String?
    public var action: ResponseImageGenerationToolAction?
    public var background: ResponseImageGenBackgroundLiteral?
    public var input_fidelity: ResponseImageGenInputFidelityLiteral?
    public var input_image_mask: ResponseImageGenerationInputImageMask?
    public var moderation: ResponseImageGenModerationLiteral?
    public var output_compression: Int?
    public var output_format: ResponseImageGenOutputFormatLiteral?
    public var partial_images: Int?
    public var quality: ResponseImageGenQualityLiteral?
}

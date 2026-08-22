//
//  ImageGenerationParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@CodableLiteral
public enum ImageGenerateStyleLiteral: String {
    case vivid, natural
}

@CodableLiteral
public enum ImageGenerateModerationLiteral: String {
    case low, auto
}

@CodableLiteral
public enum ImageGenerateQualityLiteral: String {
    case standard, hd, low, medium, high, auto
}

// MARK: - ImageGenerationParameters

@BaseModelWithExtra
public struct ImageGenerateParameters {
    public var model: String
    public var prompt: String
    public var size: String?
    public var response_format: ImageResponseFormatLiteral?
    public var n: Int?
    public var output_format: ImageOutputFormatLiteral?
    public var stream: Bool?
    public var style: ImageGenerateStyleLiteral?
    public var background: ImageBackgroundLiteral?
    public var moderation: ImageGenerateModerationLiteral?
    public var output_compression: Int?
    public var partial_images: Int?
    public var quality: ImageGenerateQualityLiteral?
    public var user: String?
}

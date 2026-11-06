//
//  ImageGenerationParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@CodableLiteral
public enum ImageGenerateStyle: String {
    case vivid, natural
}

@CodableLiteral
public enum ImageGenerateModeration: String {
    case low, auto
}

@CodableLiteral
public enum ImageGenerateQuality: String {
    case standard, hd, low, medium, high, auto
}

// MARK: - ImageGenerationParameters

@BaseModelWithExtra(encodeExtra: false)
@PublicInit
public struct ImageGenerateParameters {
    public var model: String
    public var prompt: String
    public var size: String?
    public var response_format: ImageResponseFormat?
    public var n: Int?
    public var output_format: ImageOutputFormat?
    public var stream: Bool?
    public var style: ImageGenerateStyle?
    public var background: ImageBackground?
    public var moderation: ImageGenerateModeration?
    public var output_compression: Int?
    public var partial_images: Int?
    public var quality: ImageGenerateQuality?
    public var user: String?
}

//
//  ImagesGenerateStreamResult.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ImageGeneratePartialImageEvent {
    public static let type: String = "image_generation.partial_image"
    public let b64_json: String
    public let background: ImageBackgroundLiteral
    public let created_at: Int
    public let output_format: ImageOutputFormatLiteral
    public let partial_image_index: Int
    public let quality: ImageResultQualityLiteral
    public let size: String
}
@BaseModelNoWithExtra
public struct ImageGenerateCompletedEvent {
    public static let type: String = "image_generation.completed"
    public let b64_json: String
    public let background: ImageBackgroundLiteral
    public let created_at: Int
    public let output_format: ImageOutputFormatLiteral
    public let quality: ImageResultQualityLiteral
    public let size: String
    public let usage: ImagesUsage
}

@CodableByConstant
public enum ImagesGenerateStreamResult {
    case partialImage(ImageGeneratePartialImageEvent)
    case completed(ImageGenerateCompletedEvent)
}

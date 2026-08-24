//
//  ImagesEditStreamResult.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ImageEditPartialImageEvent {
    public static let type: String = "image_edit.partial_image"
    public let b64_json: String
    public let background: ImageBackgroundLiteral
    public let created_at: Int
    public let output_format: ImageOutputFormatLiteral
    public let partial_image_index: Int
    public let quality: ImageResultQualityLiteral
    public let size: String
}
@BaseModelNoWithExtra
public struct ImageEditCompletedEvent {
    public static let type: String = "image_edit.completed"
    public let b64_json: String
    public let background: ImageBackgroundLiteral
    public let created_at: Int
    public let output_format: ImageOutputFormatLiteral
    public let quality: ImageResultQualityLiteral
    public let size: String
    public let usage: ImagesUsage
}

@CodableByConstant
@nonexhaustive
public enum ImagesEditStreamResult {
    case partialImage(ImageEditPartialImageEvent)
    case completed(ImageEditCompletedEvent)
}

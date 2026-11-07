//
//  ImagesEditStreamResult.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct ImageEditPartialImageEvent {
    public static let type: String = "image_edit.partial_image"
    public let b64_json: String
    public let background: ImageBackground
    public let created_at: Int
    public let output_format: ImageOutputFormat
    public let partial_image_index: Int
    public let quality: ImageResultQuality
    public let size: String
}
@BaseModelNoWithExtra
@PublicInit
public struct ImageEditCompletedEvent {
    public static let type: String = "image_edit.completed"
    public let b64_json: String
    public let background: ImageBackground
    public let created_at: Int
    public let output_format: ImageOutputFormat
    public let quality: ImageResultQuality
    public let size: String
    public let usage: ImagesUsage
}

@CodableByConstant
@nonexhaustive
public enum ImagesEditStreamResult {
    case partialImage(ImageEditPartialImageEvent)
    case completed(ImageEditCompletedEvent)
}

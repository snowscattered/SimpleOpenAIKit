//
//  ImagesGenerateResult.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct ImageGenerateResult {
    public let created: Int
    public let background: ImageBackground?
    public let data: [ImageResultImage]?
    public let output_format: ImageOutputFormat?
    public let quality: ImageResultQuality?
    public let size: String?
    public let usage: ImagesUsage?
}

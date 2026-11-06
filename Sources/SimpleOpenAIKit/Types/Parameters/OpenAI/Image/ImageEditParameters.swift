//
//  ImageEditParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

// MARK: - Edit Literals

@CodableLiteral
public enum ImageEditQuality: String {
    case standard, low, medium, high, auto
}

@CodableLiteral
public enum ImageInputFidelity: String {
    case high, low
}

// MARK: - FileInput

@SingleOrArray
public enum ImageFileInput {
    case file(FileParameters)
    case array([FileParameters])
}

// MARK: - ImageEditParameters

@BaseModelWithExtra(encodeExtra: false)
@PublicInit
public struct ImageEditParameters {
    public var model: String
    public var prompt: String
    public var image: ImageFileInput
    public var size: String?
    public var response_format: ImageResponseFormat?
    public var n: Int?
    public var quality: ImageEditQuality?
    public var output_format: ImageOutputFormat?
    public var stream: Bool?
    public var background: ImageBackground?
    public var input_fidelity: ImageInputFidelity?
    public var output_compression: Int?
    public var partial_images: Int?
    public var user: String?
}

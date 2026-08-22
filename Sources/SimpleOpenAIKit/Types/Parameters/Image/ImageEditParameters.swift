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
public enum ImageEditQualityLiteral: String {
    case standard, low, medium, high, auto
}

@CodableLiteral
public enum ImageInputFidelityLiteral: String {
    case high, low
}

// MARK: - FileInput

@SingleOrArray
public enum ImageFileInput {
    case file(FileParameters)
    case array([FileParameters])
}
extension ImageFileInput: ExpressibleByArrayLiteral {
    public init(_ file: FileParameters)                   { self = .file(file) }
    public init(arrayLiteral elements: FileParameters...) { self = .array(elements) }
}

// MARK: - ImageEditParameters

@BaseModelWithExtra
public struct ImageEditParameters {
    public var model: String
    public var prompt: String
    public var image: ImageFileInput
    public var size: String?
    public var response_format: ImageResponseFormatLiteral?
    public var n: Int?
    public var quality: ImageEditQualityLiteral?
    public var output_format: ImageOutputFormatLiteral?
    public var stream: Bool?
    public var background: ImageBackgroundLiteral?
    public var input_fidelity: ImageInputFidelityLiteral?
    public var output_compression: Int?
    public var partial_images: Int?
    public var user: String?
}

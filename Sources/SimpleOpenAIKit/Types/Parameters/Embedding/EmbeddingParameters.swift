//
//  EmbeddingParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@SingleOrArray
public enum EmbeddingInput {
    case string(String)
    case array([String])
}
extension EmbeddingInput: ExpressibleByStringLiteral, ExpressibleByArrayLiteral {
    public init(stringLiteral value: String)      { self = .string(value) }
    public init(arrayLiteral elements: String...) { self = .array(elements) }
}

@CodableLiteral
public enum EmbeddingEncoderFormatLiteral: String {
    case float, base64
}

@BaseModelWithExtra
public struct EmbeddingParameters {
    public var model: String
    public var input: EmbeddingInput
    public var dimensions: Int?
    public var encoding_format: EmbeddingEncoderFormatLiteral?
    public var user: String?
}

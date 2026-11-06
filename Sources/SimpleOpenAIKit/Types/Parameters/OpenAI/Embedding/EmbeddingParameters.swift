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

@CodableLiteral
public enum EmbeddingEncoderFormat: String {
    case float, base64
}

@BaseModelWithExtra(encodeExtra: false)
@PublicInit
public struct EmbeddingParameters {
    public var model: String
    public var input: EmbeddingInput
    public var dimensions: Int?
    public var encoding_format: EmbeddingEncoderFormat?
    public var user: String?
}

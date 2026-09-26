//
//  EmbeddingCreateResult.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct EmbeddingData {
    public static let object: String = "embedding"
    public let embedding: [Float]
    public let index: Int
}
@BaseModelNoWithExtra
@PublicInit
public struct EmbeddingUsage {
    public let prompt_tokens: Int
    public let total_tokens: Int
}
@BaseModelNoWithExtra
@PublicInit
public struct EmbeddingCreateResult {
    public static let object: String = "list"
    public let data: [EmbeddingData]
    public let model: String
    public let usage: EmbeddingUsage
}

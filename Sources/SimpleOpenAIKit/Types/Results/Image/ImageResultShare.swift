//
//  ImageShare.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

// Shared Literals
@CodableLiteral
public enum ImageResultQualityLiteral: String {
    case low
    case medium
    case high
    case auto
}

// Shared Image type
@BaseModelNoWithExtra
public struct ImageResultImage {
    public let b64_json: String?
    public let revised_prompt: String?
    public let url: String?
}

// Shared Token Details
@BaseModelNoWithExtra
public struct ImageInputTokensDetails {
    public let image_tokens: Int
    public let text_tokens: Int
}
@BaseModelNoWithExtra
public struct ImageOutputTokensDetails {
    public let image_tokens: Int
    public let text_tokens: Int
}
@BaseModelNoWithExtra
public struct ImagesUsage {
    public let input_tokens: Int
    public let output_tokens: Int
    public let total_tokens: Int
    public let input_tokens_details: ImageInputTokensDetails
    public let output_tokens_details: ImageOutputTokensDetails?
}

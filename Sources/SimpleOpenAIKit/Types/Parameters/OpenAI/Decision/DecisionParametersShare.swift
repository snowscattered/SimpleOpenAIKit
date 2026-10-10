//
//  DecisionParametersShare.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/10/7.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct DecisionInputText {
    public static let type: String = "input_text"
    public var text: String
}
extension DecisionInputText: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(text: value)
    }
}

@CodableLiteral
public enum DecisionInputImageDetail: String {
    case low, high, auto, original
}

@BaseModelNoWithExtra
@PublicInit
public struct DecisionInputImage {
    public static let type: String = "input_image"
    public var image_url: String
    public var detail: DecisionInputImageDetail?
}
extension DecisionInputImage: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(image_url: value)
    }
}

@CodableByConstant
public enum DecisionInputPart {
    case input_text(DecisionInputText)
    case input_image(DecisionInputImage)
}

@SingleOrArray
public enum DecisionInputMessageContent {
    case string(String)
    case array([DecisionInputPart])
}

@BaseModelNoWithExtra
@PublicInit
public struct DecisionInputMessageParam {
    public static let role: String = "user"
    public static let type: String = "message"
    public var content: DecisionInputMessageContent
}

@SingleOrArray
public enum DecisionInputOrMessages {
    case string(String)
    case array([DecisionInputMessageParam])
}

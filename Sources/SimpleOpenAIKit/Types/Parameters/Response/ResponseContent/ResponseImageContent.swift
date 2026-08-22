//
//  ResponseImageContent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@CodableLiteral
public enum ResponseImageDetailLiteral: String {
    case low, high, auto
}

@BaseModelNoWithExtra
public struct ResponseImageContent {
    public static let type: String = "input_image"
    public var image_url: String
    public var detail: ResponseImageDetailLiteral?
    public var file_id: String?
}
extension ResponseImageContent: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) { self = .init(image_url: value) }
}

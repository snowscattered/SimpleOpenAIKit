//
//  ResponseTextContent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ResponseTextContent {
    public static let type: String = "input_text"
    public var text: String
}
extension ResponseTextContent: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) { self = .init(text: value) }
}

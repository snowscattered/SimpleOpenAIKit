//
//  ResponseEncryptedContent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/6/26.
//

import Foundation
import SimpleCodableMacro

// Codex Agent
@BaseModelNoWithExtra
public struct ResponseEncryptedContent {
    public static let type: String = "encrypted_content"
    public var encrypted_content: String
}
extension ResponseEncryptedContent: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) { self = .init(encrypted_content: value) }
}

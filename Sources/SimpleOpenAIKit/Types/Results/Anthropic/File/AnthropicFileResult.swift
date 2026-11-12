//
//  AnthropicFileResult.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/11/11.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct AnthropicFileResult {
    public static let type: String = "file"
    public var id: String
    public var created_at: String
    public var filename: String
    public var mime_type: String
    public var size_bytes: Int
    public var downloadable: Bool?
    public var expires_at: String?
}

@BaseModelNoWithExtra
@PublicInit
public struct AnthropicFileDeletedResult {
    public static let type: String = "file_deleted"
    public let id: String
}

//
//  UploadResult.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/7/26.
//

import Foundation
import SimpleCodableMacro

@CodableLiteral
public enum UploadStatus: String {
    case pending
    case completed
    case cancalled
    case expired
}
@BaseModelNoWithExtra
public struct UploadResult {
    public static let object: String = "upload"
    public let id: String
    public let created_at: Int
    public let file: FileResult?
    public let filename: String
    public let bytes: Int
    public let purpose: String
    public let status: UploadStatus
    public let expires_at: Int
}

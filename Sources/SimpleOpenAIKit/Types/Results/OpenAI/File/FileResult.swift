//
//  FileResult.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro


@CodableLiteral
public enum FileStatusLiteral: String {
    case uploaded, processed, error
}
@BaseModelNoWithExtra
@PublicInit
public struct FileResult {
    public static let object: String = "file"
    public let id: String
    public let filename: String
    public let purpose: String // FilePurposeLiteral
    public let bytes: Int?
    public let created_at: Int?
    public let status: FileStatusLiteral?
    public let expires_at: Int?
    public let status_details: String?
}
@BaseModelNoWithExtra
@PublicInit
public struct FileDeleted {
    public static let object: String = "file"
    public let id: String
    public let deleted: Bool
}

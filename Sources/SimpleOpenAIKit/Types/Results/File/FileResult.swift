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
    case uploaded
    case processed
    case error
}
@BaseModelNoWithExtra
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
public struct FileDeleted {
    public static let object: String = "file"
    public let id: String
    public let deleted: Bool
}

//
//  ModelResult.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ModelResult {
//    public static let object: String = "model"
    public let object: String
    public let id: String
    public let created: Int
    public let owned_by: String
    public let shutdown_date: String?
}
@BaseModelNoWithExtra
public struct ModelDeletedResult {
    public let id: String
    public let deleted: Bool
    public let object: String
}

//
//  ResponseErrorEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ResponseErrorEvent {
    public static let type: String = "error"
    public let code: String?
    public let message: String
    public let param: String?
    public let sequence_number: Int
}

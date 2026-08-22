//
//  ResponseIncompleteEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ResponseIncompleteEvent {
    public static let type: String = "response.incomplete"
    public let response: ResponseCreateResult
    public let sequence_number: Int
}

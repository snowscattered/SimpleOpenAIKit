//
//  ResponseCompletedEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ResponseCompletedEvent {
    public static let type: String = "response.completed"
    public let response: ResponseCreateResult
    public let sequence_number: Int
}

//
//  ResponseInProgressEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ResponseInProgressEvent {
    public static let type: String = "response.in_progress"
    public let response: ResponseCreateResult
    public let sequence_number: Int
}

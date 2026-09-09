//
//  ResponseFunctionCallEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ResponseFunctionCallArgumentsDeltaEvent {
    public static let type: String = "response.function_call_arguments.delta"
    public let delta: String
    public let item_id: String
    public let output_index: Int
    public let sequence_number: Int
}
@BaseModelNoWithExtra
public struct ResponseFunctionCallArgumentsDoneEvent {
    public static let type: String = "response.function_call_arguments.done"
    public let arguments: String
    public let item_id: String
    public let output_index: Int
    public let sequence_number: Int
}

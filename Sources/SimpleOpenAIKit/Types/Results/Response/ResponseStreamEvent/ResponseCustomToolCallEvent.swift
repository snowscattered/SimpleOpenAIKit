//
//  ResponseCustomToolCallEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ResponseCustomToolCallInputDeltaEvent {
    public static let type: String = "response.custom_tool_call_input.delta"
    public let delta: String
    public let item_id: String
    public let output_index: Int
    public let sequence_number: Int
}
@BaseModelNoWithExtra
public struct ResponseCustomToolCallInputDoneEvent {
    public static let type: String = "response.custom_tool_call_input.done"
    public let input: String
    public let item_id: String
    public let output_index: Int
    public let sequence_number: Int
}

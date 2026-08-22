//
//  MessageInputJSONDelta.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct MessageInputJSONDelta {
    public static let type: String = "input_json_delta"
    public let partial_json: String
}

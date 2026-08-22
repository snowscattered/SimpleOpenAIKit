//
//  MessageThinkingDelta.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct MessageThinkingDelta {
    public static let type: String = "thinking_delta"
    public let thinking: String
}

//
//  MessageTextDelta.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct MessageTextDelta {
    public static let type: String = "text_delta"
    public let text: String
}

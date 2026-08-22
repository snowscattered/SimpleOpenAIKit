//
//  MessageSignatureDelta.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct MessageSignatureDelta {
    public static let type: String = "signature_delta"
    public let signature: String
}

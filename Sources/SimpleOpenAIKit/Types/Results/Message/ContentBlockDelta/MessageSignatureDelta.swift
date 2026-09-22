//
//  MessageSignatureDelta.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct MessageSignatureDelta {
    public static let type: String = "signature_delta"
    public let signature: String
}

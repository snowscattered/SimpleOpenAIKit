//
//  ChatFunctionMessageTypes.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ChatFunctionMessage {
    public static let role: String = "function"
    public var content: String?
    public var name: String?
}

//
//  ChatDeveloperMessageTypes.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ChatDeveloperMessage {
    public static let role: String = "developer"
    public var content: ChatStringOrContentPartText
    public var name: String?
}

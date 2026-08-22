//
//  MessageThinkingBlock.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct MessageThinkingBlock {
    public static let type: String = "thinking"
    public var thinking: String
    public var signature: String?
}

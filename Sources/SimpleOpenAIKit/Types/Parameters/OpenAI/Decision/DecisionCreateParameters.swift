//
//  DecisionCreateParameters.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/10/7.
//

import Foundation
import SimpleCodableMacro

@BaseModelWithExtra(encodeExtra: false)
@PublicInit
public struct DecisionCreateParameters {
    public var input: DecisionInputOrMessages
    public var model: String
    public var questions: [DecisionQuestion]
    public var safety_identifier: String?
}

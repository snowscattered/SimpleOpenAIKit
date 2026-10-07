//
//  DecisionQuestionPredicate.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/10/7.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct DecisionQuestionPredicate {
    public static let type: String = "predicate"
    public var name: String?
    public var instructions: String
}

//
//  DecisionAnswerPredicate.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/10/7.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct DecisionAnswerPredicate {
    public static let type: String = "predicate"
    public let name: String?
    public let probability: Double
}

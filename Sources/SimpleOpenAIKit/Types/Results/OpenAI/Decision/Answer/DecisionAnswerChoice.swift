//
//  DecisionAnswerChoice.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/10/7.
//

import Foundation
import SimpleCodableMacro

@CodableTraversal
public enum DecisionAnswerChoiceValue {
    case string(String)
    case bool(Bool)
}
extension DecisionAnswerChoiceValue: ExpressibleByStringLiteral, ExpressibleByBooleanLiteral {
    public init(stringLiteral value: String) { self = .string(value) }
    public init(booleanLiteral value: Bool) { self = .bool(value) }
}
public extension DecisionAnswerChoiceValue {
    var value: String {
        switch self {
        case .string(let str): return str
        case .bool(let bool):  return bool ? "__TRUE__" : "__FALSE__"
        }
    }
}
@BaseModelNoWithExtra
@PublicInit
public struct DecisionAnswerChoiceProbability {
    public let value: DecisionAnswerChoiceValue
    public let probability: Double
}

@BaseModelNoWithExtra
@PublicInit
public struct DecisionAnswerChoice {
    public static let type: String = "choice"
    public let name: String?
    public let choice: DecisionAnswerChoiceValue
    public let confidence: Double
    public let probabilities: [DecisionAnswerChoiceProbability]
}

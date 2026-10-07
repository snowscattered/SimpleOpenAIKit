//
//  DecisionQuestionChoice.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/10/7.
//

import Foundation
import SimpleCodableMacro

@CodableTraversal
public enum DecisionQuestionChoiceValue {
    case string(String)
    case bool(Bool)
}
extension DecisionQuestionChoiceValue: ExpressibleByStringLiteral, ExpressibleByBooleanLiteral {
    public init(stringLiteral value: String) { self = .string(value) }
    public init(booleanLiteral value: Bool) { self = .bool(value) }
}


@BaseModelNoWithExtra
@PublicInit
public struct DecisionQuestionChoiceChoice {
    public var value: DecisionQuestionChoiceValue
    public var description: String?
}
extension DecisionQuestionChoiceChoice: ExpressibleByStringLiteral, ExpressibleByBooleanLiteral {
    public init(stringLiteral value: String) { self = .init(value: .string(value)) }
    public init(booleanLiteral value: Bool) { self = .init(value: .bool(value)) }
}

@BaseModelNoWithExtra
@PublicInit
public struct DecisionQuestionChoice {
    public static let type: String = "choice"
    public var name: String?
    public var instructions: String
    public var choices: [DecisionQuestionChoiceChoice]
}

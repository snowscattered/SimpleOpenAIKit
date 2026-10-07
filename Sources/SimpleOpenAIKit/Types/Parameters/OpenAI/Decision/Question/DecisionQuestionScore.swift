//
//  DecisionQuestionScore.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/10/7.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct DecisionQuestionScoreLevel {
    public var label: String
    public var description: String?
}
extension DecisionQuestionScoreLevel: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) { self = .init(label: value) }
}

@BaseModelNoWithExtra
@PublicInit
public struct DecisionQuestionScore {
    public static let type: String = "score"
    public var name: String?
    public var instructions: String
    public var levels: [DecisionQuestionScoreLevel]
}

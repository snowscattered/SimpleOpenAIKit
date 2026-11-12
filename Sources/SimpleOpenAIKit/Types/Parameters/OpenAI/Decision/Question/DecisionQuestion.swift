//
//  DecisionQuestion.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/10/7.
//

import Foundation
import SimpleCodableMacro

@CodableByConstant
@nonexhaustive
public enum DecisionQuestion {
    case predicate(DecisionQuestionPredicate)
    case choice(DecisionQuestionChoice)
    case score(DecisionQuestionScore)
}

public extension DecisionQuestion {
    static func predicate(
        name: String? = nil,
        instructions: String
    ) -> DecisionQuestion {
        .predicate(.init(name: name, instructions: instructions))
    }

    static func choice(
        name: String? = nil,
        instructions: String,
        choices: [DecisionQuestionChoiceChoice]
    ) -> DecisionQuestion {
        .choice(.init(name: name, instructions: instructions, choices: choices))
    }

    static func score(
        name: String? = nil,
        instructions: String,
        levels: [DecisionQuestionScoreLevel]
    ) -> DecisionQuestion {
        .score(.init(name: name, instructions: instructions, levels: levels))
    }
}

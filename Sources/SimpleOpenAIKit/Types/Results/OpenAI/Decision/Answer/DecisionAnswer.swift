//
//  DecisionAnswer.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/10/7.
//

import Foundation
import SimpleCodableMacro

@CodableByConstant
@nonexhaustive
public enum DecisionAnswer {
    case predicate(DecisionAnswerPredicate)
    case choice(DecisionAnswerChoice)
    case score(DecisionAnswerScore)
    case refusal(DecisionAnswerRefusal)
}

public extension DecisionAnswer {
    var type: String {
        switch self {
        case .predicate: return DecisionAnswerPredicate.type
        case .choice:    return DecisionAnswerChoice.type
        case .score:     return DecisionAnswerScore.type
        case .refusal:   return DecisionAnswerRefusal.type
        }
    }

    var confidence: Double? {
        switch self {
        case .choice(let value): return value.confidence
        case .score(let value):  return value.confidence
        case .predicate, .refusal: return nil
        }
    }

    var probability: Double? {
        switch self {
        case .predicate(let value): return value.probability
        case .choice, .score, .refusal: return nil
        }
    }
}

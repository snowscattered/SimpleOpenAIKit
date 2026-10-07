//
//  DecisionAnswerScore.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/10/7.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct DecisionAnswerScoreProbability {
    public let value: Int
    public let label: String
    public let probability: Double
}

@BaseModelNoWithExtra
@PublicInit
public struct DecisionAnswerScore {
    public static let type: String = "score"
    public let name: String?
    public let score: Double
    public let confidence: Double
    public let probabilities: [DecisionAnswerScoreProbability]
}

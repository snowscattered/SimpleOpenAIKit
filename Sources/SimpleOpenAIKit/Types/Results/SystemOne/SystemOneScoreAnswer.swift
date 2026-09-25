//
//  SystemOneScoreAnswer.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct SystemOneScoreAnswer {
    public static let type: String = "score"
    public let score: Double
    public let legend: [String: SystemOneJSONConent]
    public let probabilities: [String: Double]
    public let confidence: Double
}

public extension SystemOneScoreAnswer {
    func probability(forLevel level: Int) -> Double? {
        probabilities[String(level)]
    }
    func legend(forLevel level: Int) -> SystemOneJSONConent? {
        legend[String(level)]
    }
    var levels: [(level: Int, description: SystemOneJSONConent, probability: Double)] {
        legend.keys.compactMap { key -> (level: Int, description: SystemOneJSONConent, probability: Double)? in
            guard let index = Int(key), let description = legend[key] else { return nil }
            return (index, description, probabilities[key] ?? 0)
        }
        .sorted { $0.level < $1.level }
    }
}

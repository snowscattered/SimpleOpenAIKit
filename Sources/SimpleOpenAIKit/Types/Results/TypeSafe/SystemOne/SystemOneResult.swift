//
//  SystemOneResult.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct SystemOneUsage {
    public let input_tokens: Int
    public let output_tokens: Int
}

@BaseModelNoWithExtra
@PublicInit
public struct SystemOneResult {
    public let model: String
    public let answers: [String: SystemOneAnswer]
    public let usage: SystemOneUsage
}

public extension SystemOneResult {
    var nouls: [String: SystemOneNoulAnswer] {
        var grouped: [String: SystemOneNoulAnswer] = [:]
        for (name, answer) in answers {
            if case .noul(let value) = answer { grouped[name] = value }
        }
        return grouped
    }
    var choices: [String: SystemOneChoiceAnswer] {
        var grouped: [String: SystemOneChoiceAnswer] = [:]
        for (name, answer) in answers {
            if case .choice(let value) = answer { grouped[name] = value }
        }
        return grouped
    }
    var scores: [String: SystemOneScoreAnswer] {
        var grouped: [String: SystemOneScoreAnswer] = [:]
        for (name, answer) in answers {
            if case .score(let value) = answer { grouped[name] = value }
        }
        return grouped
    }
}

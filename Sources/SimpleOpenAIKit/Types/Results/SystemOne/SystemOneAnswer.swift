//
//  SystemOneAnswer.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Foundation
import SimpleCodableMacro

// MARK: - Unknown Answer
@BaseModelWithExtra
@PublicInit
public struct SystemOneUnknownAnswer {
    public var type: String
}

// MARK: - Answer Union

@CodableByConstant(defaultCase: "unknown")
@nonexhaustive
public enum SystemOneAnswer {
    case noul(SystemOneNoulAnswer)
    case choice(SystemOneChoiceAnswer)
    case score(SystemOneScoreAnswer)
    case unknown(SystemOneUnknownAnswer)
}

public extension SystemOneAnswer {
    var type: String {
        switch self {
        case .noul:              return SystemOneNoulAnswer.type
        case .choice:            return SystemOneChoiceAnswer.type
        case .score:             return SystemOneScoreAnswer.type
        case .unknown(let v):    return v.type
        }
    }
    var confidence: Double? {
        switch self {
        case .noul:              return nil
        case .choice(let v):     return v.confidence
        case .score(let v):      return v.confidence
        case .unknown:           return nil
        }
    }
}

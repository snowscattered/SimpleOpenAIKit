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
    case noul(SystemOneAnswerNoul)
    case choice(SystemOneAnswerChoice)
    case score(SystemOneAnswerScore)
    case box(SystemOneAnswerBox)
    case unknown(SystemOneUnknownAnswer)
}

public extension SystemOneAnswer {
    var confidence: Double? {
        switch self {
        case .noul:              return nil
        case .choice(let v):     return v.confidence
        case .score(let v):      return v.confidence
        case .box(let v):        return v.confidence
        case .unknown:           return nil
        }
    }
}

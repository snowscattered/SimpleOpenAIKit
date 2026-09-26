//
//  SystemOneQuestion.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Foundation
import SimpleCodableMacro

// MARK: - Unkowned Question
@BaseModelWithExtra
public struct SystemOneUnknownQuestion {
    public var type: String
    public init(type: String, extra: [String : BaseType]) {
        self.type = type
        self.extra = extra
    }
}

// MARK: - Question Union
@CodableByConstant(defaultCase: "unkowned")
@nonexhaustive
public enum SystemOneQuestion {
    case noul(SystemOneNoulQuestion)
    case choice(SystemOneChoiceQuestion)
    case score(SystemOneScoreQuestion)
    case unkowned(SystemOneUnknownQuestion)
}

public extension SystemOneQuestion {
    var type: String {
        switch self {
        case .noul:            return SystemOneNoulQuestion.type
        case .choice:          return SystemOneChoiceQuestion.type
        case .score:           return SystemOneScoreQuestion.type
        case .unkowned(let v): return v.type
        }
    }

    static func noul(
        instructions: SystemOneJSONConent,
        criteria: SystemOneNoulCriteria? = nil
    ) -> SystemOneQuestion {
        .noul(.init(instructions: instructions, criteria: criteria))
    }
    static func choice(
        instructions: SystemOneJSONConent,
        criteria: [String: SystemOneJSONConent?]
    ) -> SystemOneQuestion {
        .choice(.init(instructions: instructions, criteria: criteria))
    }
    static func score(
        instructions: SystemOneJSONConent,
        criteria: [SystemOneJSONConent]
    ) -> SystemOneQuestion {
        .score(.init(instructions: instructions, criteria: criteria))
    }
}

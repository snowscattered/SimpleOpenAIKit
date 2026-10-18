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
    public init(type: String, _ format: [String : BaseType]) {
        self.type = type
        self.extra = format
    }
}

// MARK: - Question Union
@CodableByConstant(defaultCase: "unkowned")
@nonexhaustive
public enum SystemOneQuestion {
    case noul(SystemOneQuestionNoul)
    case choice(SystemOneQuestionChoice)
    case score(SystemOneQuestionScore)
    case box(SystemOneQuestionBox)
    case unkowned(SystemOneUnknownQuestion)
}

public extension SystemOneQuestion {
    var type: String {
        switch self {
        case .noul:            return SystemOneQuestionNoul.type
        case .choice:          return SystemOneQuestionChoice.type
        case .score:           return SystemOneQuestionScore.type
        case .box:             return SystemOneQuestionBox.type
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
    static func box(
        instructions: SystemOneJSONConent? = nil
    ) -> SystemOneQuestion {
        .box(.init(instructions: instructions))
    }
}

extension SystemOneQuestion {
    func resolved(
        _ aliases: [String: String],
        into assets: inout [String: TypeSafeImage]
    ) -> Self {
        switch self {
        case .noul(var question):
            question.instructions = question.instructions?.resolved(
                aliases,
                into: &assets
            )
            if var criteria = question.criteria {
                criteria.`true` = criteria.`true`?.resolved(
                    aliases,
                    into: &assets
                )
                criteria.`false` = criteria.`false`?.resolved(
                    aliases,
                    into: &assets
                )
                question.criteria = criteria
            }
            return .noul(question)
        case .choice(var question):
            question.instructions = question.instructions?.resolved(
                aliases,
                into: &assets
            )
            question.criteria = question.criteria.mapValues {
                $0?.resolved(aliases, into: &assets)
            }
            return .choice(question)
        case .score(var question):
            question.instructions = question.instructions?.resolved(
                aliases,
                into: &assets
            )
            question.criteria = question.criteria.map {
                $0.resolved(aliases, into: &assets)
            }
            return .score(question)
        case .box(var question):
            question.instructions = question.instructions?.resolved(
                aliases,
                into: &assets
            )
            return .box(question)
        default: return self
        }
    }
}

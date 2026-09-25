//
//  SystemOneScoreQuestion.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct SystemOneScoreQuestion {
    public static let type: String = "score"
    public var instructions: SystemOneJSONConent?
    public var criteria: [SystemOneJSONConent]
}

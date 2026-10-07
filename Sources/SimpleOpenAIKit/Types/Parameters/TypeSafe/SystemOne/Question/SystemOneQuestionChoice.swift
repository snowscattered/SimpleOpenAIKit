//
//  SystemOneQuestionChoice.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct SystemOneQuestionChoice {
    public static let type: String = "choice"
    public var instructions: SystemOneJSONConent?
    public var criteria: [String: SystemOneJSONConent?]
}

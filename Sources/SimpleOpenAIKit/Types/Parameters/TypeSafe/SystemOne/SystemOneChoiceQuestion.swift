//
//  SystemOneChoiceQuestion.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct SystemOneChoiceQuestion {
    public static let type: String = "choice"
    public var instructions: SystemOneJSONConent?
    public var criteria: [String: SystemOneJSONConent?]
}

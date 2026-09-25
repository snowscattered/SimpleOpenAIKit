//
//  SystemOneChoiceAnswer.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct SystemOneChoiceAnswer {
    public static let type: String = "choice"
    public let choice: String
    public let probabilities: [String: Double]
    public let confidence: Double
}

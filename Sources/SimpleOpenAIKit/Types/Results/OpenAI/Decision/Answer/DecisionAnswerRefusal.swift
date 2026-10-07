//
//  DecisionAnswerRefusal.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/10/7.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct DecisionAnswerRefusal {
    public static let type: String = "refusal"
    public let name: String?
}

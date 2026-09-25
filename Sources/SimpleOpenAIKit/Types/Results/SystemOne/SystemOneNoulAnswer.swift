//
//  SystemOneNoulAnswer.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct SystemOneNoulAnswer {
    public static let type: String = "noul"
    public let noul: Double
}

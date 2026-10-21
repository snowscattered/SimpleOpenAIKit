//
//  SystemOneQuestionBox.swift
//  SimpleOpenAIKit
//
//  Created by snow on 10/19/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct SystemOneQuestionBox {
    public static let type: String = "box"
    public var instructions: SystemOneJSONConent?
}

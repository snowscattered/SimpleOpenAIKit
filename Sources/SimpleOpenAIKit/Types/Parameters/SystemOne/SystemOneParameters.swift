//
//  SystemOneParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelWithExtra
@PublicInit
public struct SystemOneParameters {
    public var model: String?
    public var state: SystemOneJSONConent
    public var questions: [String: SystemOneQuestion]
}

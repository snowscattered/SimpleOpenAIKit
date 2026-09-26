//
//  SystemOneNoulQuestion.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct SystemOneNoulQuestion {
    public static let type: String = "noul"
    public var instructions: SystemOneJSONConent?
    public var criteria: SystemOneNoulCriteria?
}

@BaseModelNoWithExtra
@PublicInit
public struct SystemOneNoulCriteria {
    public var `true`: SystemOneJSONConent?
    public var `false`: SystemOneJSONConent?
}

//
//  TypeSafeModelResult.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct TypeSafeModelResult {
    public let name: String
    public let description: String
    public let release_date: String
}

@BaseModelNoWithExtra
@PublicInit
public struct TypeSafeModelListResult {
    public let models: [TypeSafeModelResult]
}

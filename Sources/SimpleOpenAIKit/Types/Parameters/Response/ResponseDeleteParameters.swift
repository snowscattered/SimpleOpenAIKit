//
//  ResponseDeleteParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/21/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelWithExtra
@PublicInit
public struct ResponseDeleteParameters {
    @transient public var response_id: String
}

//
//  ResponseCancelParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/21/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelWithExtra
public struct ResponseCancelParameters {
    @transient public var response_id: String
}

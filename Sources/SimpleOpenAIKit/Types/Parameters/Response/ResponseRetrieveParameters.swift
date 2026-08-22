//
//  ResponseRetrieveParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/21/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelWithExtra
public struct ResponseRetrieveParameters {
    @transient public var response_id: String
    public var stream: Bool?
    public var include: [ResponseIncludeLiteral]?
    public var include_obfuscation: Bool?
    public var starting_after: Int?
}

//
//  ResponseFunctionTool.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ResponseFunctionTool {
    public static let type: String = "function"
    public var name: String
    public var description: String?
    public var parameters: [String: BaseType]?
    public var strict: Bool?
    public var defer_loading: Bool?
    public var async: Bool?
    public var allowed_callers: [ResponseToolAllowedCallers]?
    public var output_schema: [String: BaseType]?
}

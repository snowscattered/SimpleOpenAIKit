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
    public var parameters: [String: BaseType]?
    public var description: String?
    public var defer_loading: Bool?
    public var strict: Bool?
}

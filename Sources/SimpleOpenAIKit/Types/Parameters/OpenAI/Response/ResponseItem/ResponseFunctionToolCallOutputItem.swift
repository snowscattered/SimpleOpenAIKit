//
//  ResponseFunctionToolCallOutputItem.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

public typealias ResponseFunctionToolCallOutputContent = ResponseContent

@SingleOrArray
public enum ResponseFunctionToolCallOutput {
    case string(String)
    case array([ResponseFunctionToolCallOutputContent])
}

@BaseModelNoWithExtra
@PublicInit
public struct ResponseFunctionToolCallOutputItem {
    public static let type: String = "function_call_output"
    public var id: String?
    public var call_id: String?
    public var namespace: String?
    public var name: String?
    public var output: ResponseFunctionToolCallOutput
    public var caller: ResponseFunctionToolCaller?
    public var status: ResponseItemStatusLiteral?
}

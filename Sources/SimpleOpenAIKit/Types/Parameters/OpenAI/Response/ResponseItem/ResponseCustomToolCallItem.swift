//
//  ResponseCustomToolCallItem.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

public typealias ResponseCustomCallerDirect = ResponseFunctionToolCallerDirect
public typealias ResponseCustomCallerProgram = ResopnseFunctionToolCallerProgram
public typealias ResponseCustomCaller = ResponseFunctionToolCaller

@BaseModelNoWithExtra
@PublicInit
public struct ResponseCustomToolCallItem {
    public static let type: String = "custom_tool_call"
    public var id: String?
    public var call_id: String
    @BaseModelFieldAlias("async_")
    public var async: Bool?
    public var namespace: String?
    public var name: String
    public var input: String
    public var caller: ResponseCustomCaller?
}

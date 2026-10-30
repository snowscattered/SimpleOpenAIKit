//
//  ResponseFunctionToolCallItem.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct ResponseFunctionToolCallerDirect {
    public static let type: String = "direct"
}

@BaseModelNoWithExtra
@PublicInit
public struct ResopnseFunctionToolCallerProgram {
    public static let type: String = "program"
    public var caller_id: String
}
@CodableByConstant
public enum ResponseFunctionToolCaller: Codable {
    case direct(ResponseFunctionToolCallerDirect)
    case program(ResopnseFunctionToolCallerProgram)
}

@BaseModelNoWithExtra
@PublicInit
public struct ResponseFunctionToolCallItem {
    public static let type: String = "function_call"
    public var id: String?
    public var call_id: String
    @BaseModelFieldAlias("async_")
    public var async: Bool?
    public var name: String
    public var arguments: String
    public var namespace: String?
    public var caller: ResponseFunctionToolCaller?
    public var status: ResponseItemStatusLiteral?
}

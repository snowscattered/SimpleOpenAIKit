//
//  ResponseFunctionCallItem.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct ResponseFunctionCallerDirect {
    public static let type: String = "direct"
}

@BaseModelNoWithExtra
@PublicInit
public struct ResopnseFunctionCallerProgram {
    public static let type: String = "program"
    public var caller_id: String
}
@CodableByConstant
public enum ResponseFunctionCaller: Codable {
    case direct(ResponseFunctionCallerDirect)
    case program(ResopnseFunctionCallerProgram)
}

@BaseModelNoWithExtra
@PublicInit
public struct ResponseFunctionCallItem {
    public static let type: String = "function_call"
    public var id: String?
    public var call_id: String
    public var name: String
    public var arguments: String
    public var namespace: String?
    public var caller: ResponseFunctionCaller?
    public var status: ResponseItemStatusLiteral?
}

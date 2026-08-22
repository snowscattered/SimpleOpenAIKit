//
//  MessageCaller.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/27/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct MessageDirectCaller {
    public static let type: String = "direct"
}
@BaseModelNoWithExtra
public struct MessageServerToolCaller {
    public static let type: String = "code_execution_20250825"
    public var tool_id: String
}
@BaseModelNoWithExtra
public struct MessageServerToolCaller20260120 {
    public static let type: String = "code_execution_20260120"
    public var tool_id: String
}
@CodableByConstant
public enum MessageCaller {
    case Direct(MessageDirectCaller)
    case ServerToolCaller(MessageServerToolCaller)
    case ServerToolCaller20260120(MessageServerToolCaller20260120)
}

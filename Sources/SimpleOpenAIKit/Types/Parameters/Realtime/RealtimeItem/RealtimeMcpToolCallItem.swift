//
//  RealtimeMcpToolCall.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/14/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct RealtimeMcpProtocolError {
    public static let type: String = "protocol_error"
    public var code: Int
    public var message: String
}

@BaseModelNoWithExtra
public struct RealtimeMcpToolExecutionError {
    public static let type: String = "tool_execution_error"
    public var message: String
}

@BaseModelNoWithExtra
public struct RealtimeMcphttpError {
    public static let type: String = "http_error"
    public var code: Int
    public var message: String
}

@CodableByConstant
public enum McpToolCallError {
    case protocolError(RealtimeMcpProtocolError)
    case toolExecutionError(RealtimeMcpToolExecutionError)
    case httpError(RealtimeMcphttpError)
}

@BaseModelWithExtra
public struct RealtimeMcpToolCallItem {
    public static let type: String = "mcp_call"
    public var approval_request_id: String?
    public var id: String
    public var name: String
    public var arguments: String
    public var output: String?
    public var server_label: String
    public var error: McpToolCallError?
}

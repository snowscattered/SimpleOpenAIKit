//
//  RealtimeMcpApprovalResponse.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/14/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelWithExtra
public struct RealtimeMcpApprovalResponseItem {
    public static let type: String = "mcp_approval_response"
    public var id: String
    public var approval_request_id: String
    public var approve: Bool
    public var reason: String? = nil
}

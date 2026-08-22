//
//  RealtimeMcpApprovalRequest.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/14/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelWithExtra
public struct RealtimeMcpApprovalRequestItem {
    public static let type: String = "mcp_approval_request"
    public var id: String
    public var arguments: String
    public var name: String
    public var server_label: String
}

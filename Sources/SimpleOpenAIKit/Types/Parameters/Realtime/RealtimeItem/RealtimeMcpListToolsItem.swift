//
//  RealtimeMcpListTools.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/14/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct RealtimeMCPTool {
    public var input_schema: BaseType
    public var name: String
    public var annotations: BaseType?
    public var description: String?
}

@BaseModelWithExtra
@PublicInit
public struct RealtimeMcpListToolsItem {
    public static let type: String = "mcp_list_tools"
    public var id: String?
    public var tools: [RealtimeMCPTool]
    public var server_label: String
}

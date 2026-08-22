//
//  RealtimeMcpListToolsFailedEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/20/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct RealtimeMcpListToolsFailedEvent {
    public static let type: String = "mcp_list_tools.failed"
    public let event_id: String
    public let item_id: String
}

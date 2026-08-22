//
//  RealtimeMcpListToolsInProgressEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/20/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct RealtimeMcpListToolsInProgressEvent {
    public static let type: String = "mcp_list_tools.in_progress"
    public let event_id: String
    public let item_id: String
}

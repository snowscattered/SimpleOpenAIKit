//
//  RealtimeResponseMcpCallInProgressEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/20/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct RealtimeResponseMcpCallInProgressEvent {
    public static let type: String = "response.mcp_call.in_progress"
    public let event_id: String
    public let item_id: String
    public let output_index: Int
}

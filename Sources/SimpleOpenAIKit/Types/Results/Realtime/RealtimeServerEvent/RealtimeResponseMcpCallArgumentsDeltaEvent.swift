//
//  RealtimeResponseMcpCallArgumentsDeltaEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/20/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct RealtimeResponseMcpCallArgumentsDeltaEvent {
    public static let type: String = "response.mcp_call_arguments.delta"
    public let event_id: String
    public let response_id: String
    public let item_id: String
    public let output_index: Int
    public let delta: String
    public let obfuscation: String?
}

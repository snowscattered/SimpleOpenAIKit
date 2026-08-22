//
//  BetaRealtimeResponseFunctionCallArgumentsDoneEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct BetaRealtimeResponseFunctionCallArgumentsDoneEvent {
    public static let type: String = "response.function_call_arguments.done"
    public let event_id: String
    public let response_id: String
    public let item_id: String
    public let output_index: Int
    public let call_id: String
    public let arguments: String
}

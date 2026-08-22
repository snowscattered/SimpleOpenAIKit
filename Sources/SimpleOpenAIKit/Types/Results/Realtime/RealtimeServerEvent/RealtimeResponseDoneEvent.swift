//
//  RealtimeResponseDoneEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/20/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct RealtimeResponseDoneEvent {
    public static let type: String = "response.done"
    public let event_id: String
    public let response: RealtimeResponse
}

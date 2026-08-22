//
//  RealtimeResponseCancelEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/14/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct RealtimeResponseCancelEventParameters {
    public static let type: String = "response.cancel"
    public var event_id: String?
    public var response_id: String?
}

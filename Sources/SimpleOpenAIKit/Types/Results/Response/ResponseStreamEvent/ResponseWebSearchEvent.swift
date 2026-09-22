//
//  ResponseWebSearchEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/13/26.
//

import Foundation
import SimpleCodableMacro

// MARK: - ResponseWebSearchCallInProgressEvent
@BaseModelNoWithExtra
@PublicInit
public struct ResponseWebSearchCallInProgressEvent {
    public static let type: String = "response.web_search_call.in_progress"
    public let item_id: String
    public let output_index: Int
    public let sequence_number: Int
}

// MARK: - ResponseWebSearchCallSearchingEvent
@BaseModelNoWithExtra
@PublicInit
public struct ResponseWebSearchCallSearchingEvent {
    public static let type: String = "response.web_search_call.searching"
    public let item_id: String
    public let output_index: Int
    public let sequence_number: Int
}

// MARK: - ResponseWebSearchCallCompletedEvent
@BaseModelNoWithExtra
@PublicInit
public struct ResponseWebSearchCallCompletedEvent {
    public static let type: String = "response.web_search_call.completed"
    public let item_id: String
    public let output_index: Int
    public let sequence_number: Int
}

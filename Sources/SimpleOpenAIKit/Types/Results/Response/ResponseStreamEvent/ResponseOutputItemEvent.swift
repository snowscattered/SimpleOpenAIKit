//
//  ResponseOutputItemEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ResponseOutputItemAddedEvent {
    public static let type: String = "response.output_item.added"
    public let item: ResponseOutputItem
    public let output_index: Int
    public let sequence_number: Int
}
@BaseModelNoWithExtra
public struct ResponseOutputItemDoneEvent {
    public static let type: String = "response.output_item.done"
    public let item: ResponseOutputItem
    public let output_index: Int
    public let sequence_number: Int
}

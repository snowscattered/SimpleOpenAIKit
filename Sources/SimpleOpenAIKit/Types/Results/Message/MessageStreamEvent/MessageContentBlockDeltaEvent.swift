//
//  MessageContentBlockDeltaEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct MessageContentBlockDeltaEvent {
    public static let type: String = "content_block_delta"
    public let delta: MessageContentBlockDelta
    public let index: Int
}

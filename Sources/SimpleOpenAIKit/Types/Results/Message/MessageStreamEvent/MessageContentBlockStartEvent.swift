//
//  MessageContentBlockStartEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct MessageContentBlockStartEvent {
    public static let type: String = "content_block_start"
    public let content_block: MessageBlock
    public let index: Int
}

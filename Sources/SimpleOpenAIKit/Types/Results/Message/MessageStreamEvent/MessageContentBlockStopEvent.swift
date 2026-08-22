//
//  MessageContentBlockStopEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct MessageContentBlockStopEvent {
    public static let type: String = "content_block_stop"
    public let index: Int
}

//
//  MessageStartEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct MessageStartEvent {
    public static let type: String = "message_start"
    public let message: MessageCreateResult
}

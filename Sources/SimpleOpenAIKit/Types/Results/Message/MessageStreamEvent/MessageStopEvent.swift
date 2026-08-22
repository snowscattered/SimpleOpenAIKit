//
//  MessageStopEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct MessageStopEvent {
    public static let type: String = "message_stop"
}

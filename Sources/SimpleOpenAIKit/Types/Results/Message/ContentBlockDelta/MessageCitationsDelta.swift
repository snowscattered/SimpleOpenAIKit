//
//  MessageCitationsDelta.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct MessageCitationsDelta {
    public static let type: String = "citations_delta"
    public let citation: MessageCitation
}

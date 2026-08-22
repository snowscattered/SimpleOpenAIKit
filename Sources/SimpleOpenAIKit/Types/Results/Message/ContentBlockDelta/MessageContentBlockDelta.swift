//
//  MessageContentBlockDelta.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@CodableByConstant
public enum MessageContentBlockDelta {
    case citations_delta(MessageCitationsDelta)
    case input_json_delta(MessageInputJSONDelta)
    case signature_delta(MessageSignatureDelta)
    case text_delta(MessageTextDelta)
    case thinking_delta(MessageThinkingDelta)
}

//
//  MessageStreamResult.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@CodableByConstant
@nonexhaustive
public enum MessageStreamResult {
    case message_start(MessageStartEvent)
    case message_delta(MessageDeltaEvent)
    case message_stop(MessageStopEvent)
    case content_block_start(MessageContentBlockStartEvent)
    case content_block_delta(MessageContentBlockDeltaEvent)
    case content_block_stop(MessageContentBlockStopEvent)
}

public extension MessageStreamResult {
    var type: String {
        switch self {
        case .message_start:       return MessageStartEvent.type
        case .message_delta:       return MessageDeltaEvent.type
        case .message_stop:        return MessageStopEvent.type
        case .content_block_start: return MessageContentBlockStartEvent.type
        case .content_block_delta: return MessageContentBlockDeltaEvent.type
        case .content_block_stop:  return MessageContentBlockStopEvent.type
        }
    }
}

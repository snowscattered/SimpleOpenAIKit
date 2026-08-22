//
//  MessageStreamResult.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@CodableByConstant
public enum MessageStreamResult {
    case message_start(MessageStartEvent)
    case message_delta(MessageDeltaEvent)
    case message_stop(MessageStopEvent)
    case content_block_start(MessageContentBlockStartEvent)
    case content_block_delta(MessageContentBlockDeltaEvent)
    case content_block_stop(MessageContentBlockStopEvent)
}

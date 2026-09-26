//
//  BetaRealtimeEventParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/16/26.
//

import Foundation
import SimpleCodableMacro

@CodableByConstant
@nonexhaustive
public enum BetaRealtimeEventParameters {
    case conversation_create(BetaRealtimeConversationItemCreateEventParameters)
    case conversation_delete(BetaRealtimeConversationItemDeleteEventParameters)
    case conversation_retrieve(BetaRealtimeConversationItemRetrieveEventParameters)
    case conversation_truncate(BetaRealtimeConversationItemTruncateEventParameters)
    case input_audio_buffer_append(BetaRealtimeInputAudioBufferAppendEventParameters)
    case input_audio_buffer_clear(BetaRealtimeInputAudioBufferClearEventParameters)
    case input_audio_buffer_commit(BetaRealtimeInputAudioBufferCommitEventParameters)
    case output_audio_buffer_clear(BetaRealtimeOutputAudioBufferClearEventParameters)
    case response_create(BetaRealtimeResponseCreateEventParameters)
    case response_cancel(BetaRealtimeResponseCancelEventParameters)
    case session_update(BetaRealtimeSessionUpdateEventParameters)
}

public extension BetaRealtimeEventParameters {
    var type: String {
        switch self {
        case .conversation_create:       return BetaRealtimeConversationItemCreateEventParameters.type
        case .conversation_delete:       return BetaRealtimeConversationItemDeleteEventParameters.type
        case .conversation_retrieve:     return BetaRealtimeConversationItemRetrieveEventParameters.type
        case .conversation_truncate:     return BetaRealtimeConversationItemTruncateEventParameters.type
        case .input_audio_buffer_append: return BetaRealtimeInputAudioBufferAppendEventParameters.type
        case .input_audio_buffer_clear:  return BetaRealtimeInputAudioBufferClearEventParameters.type
        case .input_audio_buffer_commit: return BetaRealtimeInputAudioBufferCommitEventParameters.type
        case .output_audio_buffer_clear: return BetaRealtimeOutputAudioBufferClearEventParameters.type
        case .response_create:           return BetaRealtimeResponseCreateEventParameters.type
        case .response_cancel:           return BetaRealtimeResponseCancelEventParameters.type
        case .session_update:            return BetaRealtimeSessionUpdateEventParameters.type
        }
    }
}

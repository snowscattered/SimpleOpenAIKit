//
//  RealtimeClientEventParameter.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/15/26.
//

import Foundation
import SimpleCodableMacro

@CodableByConstant
@nonexhaustive
public enum RealtimeEventParameters {
    case conversation_create(RealtimeConversationItemCreateEventParameters)
    case conversation_delete(RealtimeConversationItemDeleteEventParameters)
    case conversation_retrieve(RealtimeConversationItemRetrieveEventParameters)
    case conversation_truncate(RealtimeConversationItemTruncateEventParameters)
    case input_audio_buffer_append(RealtimeInputAudioBufferAppendEventParameters)
    case input_audio_buffer_clear(RealtimeInputAudioBufferClearEventParameters)
    case input_audio_buffer_commit(RealtimeInputAudioBufferCommitEventParameters)
    case output_audio_buffer_clear(RealtimeOutputAudioBufferClearEventParameters)
    case response_create(RealtimeResponseCreateEventParameters)
    case response_cancel(RealtimeResponseCancelEventParameters)
    case session_update(RealtimeSessionUpdateEventParameters)
}

extension RealtimeEventParameters {
    var type: String {
        switch self {
        case .conversation_create:       return RealtimeConversationItemCreateEventParameters.type
        case .conversation_delete:       return RealtimeConversationItemDeleteEventParameters.type
        case .conversation_retrieve:     return RealtimeConversationItemRetrieveEventParameters.type
        case .conversation_truncate:     return RealtimeConversationItemTruncateEventParameters.type
        case .input_audio_buffer_append: return RealtimeInputAudioBufferAppendEventParameters.type
        case .input_audio_buffer_clear:  return RealtimeInputAudioBufferClearEventParameters.type
        case .input_audio_buffer_commit: return RealtimeInputAudioBufferCommitEventParameters.type
        case .output_audio_buffer_clear: return RealtimeOutputAudioBufferClearEventParameters.type
        case .response_create:           return RealtimeResponseCreateEventParameters.type
        case .response_cancel:           return RealtimeResponseCancelEventParameters.type
        case .session_update:            return RealtimeSessionUpdateEventParameters.type
        }
    }
}

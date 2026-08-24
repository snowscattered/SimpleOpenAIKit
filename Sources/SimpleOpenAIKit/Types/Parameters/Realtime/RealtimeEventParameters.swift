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

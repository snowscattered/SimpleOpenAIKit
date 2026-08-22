//
//  BetaRealtimeEventParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/16/26.
//

import Foundation
import SimpleCodableMacro

@CodableByConstant
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

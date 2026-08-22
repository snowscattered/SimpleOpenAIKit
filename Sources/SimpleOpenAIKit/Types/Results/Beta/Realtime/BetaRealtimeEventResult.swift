//
//  BetaRealtimeEventResult.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

@CodableByConstant(defaultCase: "unkowned")
public enum BetaRealtimeEventResult {
    // Session
    case session_created(BetaRealtimeSessionCreatedEvent)
    case session_updated(BetaRealtimeSessionUpdatedEvent)
    // Status
    case error(BetaRealtimeErrorEvent)
    case rate_limits_updated(BetaRealtimeRateLimitsUpdatedEvent)
    // Response
    case response_created(BetaRealtimeResponseCreatedEvent)
    case response_done(BetaRealtimeResponseDoneEvent)
    // ConversationItem
    case conversation_created(BetaRealtimeConversationCreatedEvent)
    case conversation_item_created(BetaRealtimeConversationItemCreatedEvent)
    case conversation_item_deleted(BetaRealtimeConversationItemDeletedEvent)
    case conversation_item_retrieved(BetaRealtimeConversationItemRetrievedEvent)
    case conversation_item_truncated(BetaRealtimeConversationItemTruncatedEvent)
    case conversation_item_input_audio_transcription_completed(BetaRealtimeConversationItemInputAudioTranscriptionCompletedEvent)
    case conversation_item_input_audio_transcription_delta(BetaRealtimeConversationItemInputAudioTranscriptionDeltaEvent)
    case conversation_item_input_audio_transcription_failed(BetaRealtimeConversationItemInputAudioTranscriptionFailedEvent)
    // OutputItem
    case response_output_item_added(BetaRealtimeResponseOutputItemAddedEvent)
    case response_output_item_done(BetaRealtimeResponseOutputItemDoneEvent)
    // ContentPart
    case response_content_part_added(BetaRealtimeResponseContentPartAddedEvent)
    case response_content_part_done(BetaRealtimeResponseContentPartDoneEvent)
    // Audio
    case response_audio_delta(BetaRealtimeResponseAudioDeltaEvent)
    case response_audio_done(BetaRealtimeResponseAudioDoneEvent)
    // AudioTranscript
    case response_audio_transcript_delta(BetaRealtimeResponseAudioTranscriptDeltaEvent)
    case response_audio_transcript_done(BetaRealtimeResponseAudioTranscriptDoneEvent)
    // Text
    case response_text_delta(BetaRealtimeResponseTextDeltaEvent)
    case response_text_done(BetaRealtimeResponseTextDoneEvent)
    // FunctionArguments
    case response_function_call_arguments_delta(BetaRealtimeResponseFunctionCallArgumentsDeltaEvent)
    case response_function_call_arguments_done(BetaRealtimeResponseFunctionCallArgumentsDoneEvent)
    // AudioBuffer
    case input_audio_buffer_speech_started(BetaRealtimeInputAudioBufferSpeechStartedEvent)
    case input_audio_buffer_speech_stopped(BetaRealtimeInputAudioBufferSpeechStoppedEvent)
    case input_audio_buffer_cleared(BetaRealtimeInputAudioBufferClearedEvent)
    case input_audio_buffer_committed(BetaRealtimeInputAudioBufferCommittedEvent)
    
    case output_audio_buffer_started(BetaRealtimeOutputAudioBufferStartedEvent)
    case output_audio_buffer_stopped(BetaRealtimeOutputAudioBufferStoppedEvent)
    case output_audio_buffer_cleared(BetaRealtimeOutputAudioBufferClearedEvent)
    // Extension OpenAI
    case unkowned(UnknownEvent)
}

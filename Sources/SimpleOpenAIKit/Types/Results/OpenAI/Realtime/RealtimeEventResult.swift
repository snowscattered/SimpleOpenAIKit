//
//  RealtimeEventResult.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/18/26.
//

import Foundation
import SimpleCodableMacro

@CodableByConstant(defaultCase: "unkowned")
@nonexhaustive
public enum RealtimeEventResult {
    // Session
    case session_created(RealtimeSessionCreatedEvent)
    case session_updated(RealtimeSessionUpdatedEvent)
    // Status
    case error(RealtimeErrorEvent)
    case rate_limits_updated(RealtimeRateLimitsUpdatedEvent)
    // Response
    case response_created(RealtimeResponseCreatedEvent)
    case response_done(RealtimeResponseDoneEvent)
    // ConversationItem
    case conversation_created(RealtimeConversationCreatedEvent)
    case conversation_item_created(RealtimeConversationItemCreatedEvent)
    case conversation_item_deleted(RealtimeConversationItemDeletedEvent)
    case conversation_item_retrieved(RealtimeConversationItemRetrievedEvent)
    case conversation_item_truncated(RealtimeConversationItemTruncatedEvent)
    case conversation_item_input_audio_transcription_completed(RealtimeConversationItemInputAudioTranscriptionCompletedEvent)
    case conversation_item_input_audio_transcription_delta(RealtimeConversationItemInputAudioTranscriptionDeltaEvent)
    case conversation_item_input_audio_transcription_failed(RealtimeConversationItemInputAudioTranscriptionFailedEvent)
    // OutputItem
    case response_output_item_added(RealtimeResponseOutputItemAddedEvent)
    case response_output_item_done(RealtimeResponseOutputItemDoneEvent)
    // ContentPart
    case response_content_part_added(RealtimeResponseContentPartAddedEvent)
    case response_content_part_done(RealtimeResponseContentPartDoneEvent)
    // Audio
    case response_audio_delta(RealtimeResponseAudioDeltaEvent)
    case response_audio_done(RealtimeResponseAudioDoneEvent)
    // AudioTranscript
    case response_audio_transcript_delta(RealtimeResponseAudioTranscriptDeltaEvent)
    case response_audio_transcript_done(RealtimeResponseAudioTranscriptDoneEvent)
    // Text
    case response_text_delta(RealtimeResponseTextDeltaEvent)
    case response_text_done(RealtimeResponseTextDoneEvent)
    // FunctionArguments
    case response_function_call_arguments_delta(RealtimeResponseFunctionCallArgumentsDeltaEvent)
    case response_function_call_arguments_done(RealtimeResponseFunctionCallArgumentsDoneEvent)
    // AudioBuffer
    case input_audio_buffer_speech_started(RealtimeInputAudioBufferSpeechStartedEvent)
    case input_audio_buffer_speech_stopped(RealtimeInputAudioBufferSpeechStoppedEvent)
    case input_audio_buffer_cleared(RealtimeInputAudioBufferClearedEvent)
    case input_audio_buffer_committed(RealtimeInputAudioBufferCommittedEvent)
    
    case output_audio_buffer_started(RealtimeOutputAudioBufferStartedEvent)
    case output_audio_buffer_stopped(RealtimeOutputAudioBufferStoppedEvent)
    case output_audio_buffer_cleared(RealtimeOutputAudioBufferClearedEvent)
    // MCP
    case mcp_list_tool_in_progress(RealtimeMcpListToolsInProgressEvent)
    case mcp_list_tool_completed(RealtimeMcpListToolsCompletedEvent)
    case mcp_list_tool_failed(RealtimeMcpListToolsFailedEvent)
    case mcp_call_in_progress(RealtimeResponseMcpCallInProgressEvent)
    case mcp_call_completed(RealtimeResponseMcpCallCompletedEvent)
    case mcp_call_failed(RealtimeResponseMcpCallFailedEvent)
    // Extension OpenAI
    case unkowned(UnknownEvent)
}

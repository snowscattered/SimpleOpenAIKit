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

public extension RealtimeEventResult {
    var type: String {
        switch self {
        // Session
        case .session_created:                        return RealtimeSessionCreatedEvent.type
        case .session_updated:                        return RealtimeSessionUpdatedEvent.type
        // Status
        case .error:                                  return RealtimeErrorEvent.type
        case .rate_limits_updated:                    return RealtimeRateLimitsUpdatedEvent.type
        // Response
        case .response_created:                       return RealtimeResponseCreatedEvent.type
        case .response_done:                          return RealtimeResponseDoneEvent.type
        // ConversationItem
        case .conversation_created:                   return RealtimeConversationCreatedEvent.type
        case .conversation_item_created:              return RealtimeConversationItemCreatedEvent.type
        case .conversation_item_deleted:              return RealtimeConversationItemDeletedEvent.type
        case .conversation_item_retrieved:            return RealtimeConversationItemRetrievedEvent.type
        case .conversation_item_truncated:            return RealtimeConversationItemTruncatedEvent.type
        case .conversation_item_input_audio_transcription_completed: return RealtimeConversationItemInputAudioTranscriptionCompletedEvent.type
        case .conversation_item_input_audio_transcription_delta:     return RealtimeConversationItemInputAudioTranscriptionDeltaEvent.type
        case .conversation_item_input_audio_transcription_failed:    return RealtimeConversationItemInputAudioTranscriptionFailedEvent.type
        // OutputItem
        case .response_output_item_added:             return RealtimeResponseOutputItemAddedEvent.type
        case .response_output_item_done:              return RealtimeResponseOutputItemDoneEvent.type
        // ContentPart
        case .response_content_part_added:            return RealtimeResponseContentPartAddedEvent.type
        case .response_content_part_done:             return RealtimeResponseContentPartDoneEvent.type
        // Audio
        case .response_audio_delta:                   return RealtimeResponseAudioDeltaEvent.type
        case .response_audio_done:                    return RealtimeResponseAudioDoneEvent.type
        // AudioTranscript
        case .response_audio_transcript_delta:        return RealtimeResponseAudioTranscriptDeltaEvent.type
        case .response_audio_transcript_done:         return RealtimeResponseAudioTranscriptDoneEvent.type
        // Text
        case .response_text_delta:                    return RealtimeResponseTextDeltaEvent.type
        case .response_text_done:                     return RealtimeResponseTextDoneEvent.type
        // FunctionArguments
        case .response_function_call_arguments_delta: return RealtimeResponseFunctionCallArgumentsDeltaEvent.type
        case .response_function_call_arguments_done:  return RealtimeResponseFunctionCallArgumentsDoneEvent.type
        // AudioBuffer
        case .input_audio_buffer_speech_started:      return RealtimeInputAudioBufferSpeechStartedEvent.type
        case .input_audio_buffer_speech_stopped:      return RealtimeInputAudioBufferSpeechStoppedEvent.type
        case .input_audio_buffer_cleared:             return RealtimeInputAudioBufferClearedEvent.type
        case .input_audio_buffer_committed:           return RealtimeInputAudioBufferCommittedEvent.type
        case .output_audio_buffer_started:            return RealtimeOutputAudioBufferStartedEvent.type
        case .output_audio_buffer_stopped:            return RealtimeOutputAudioBufferStoppedEvent.type
        case .output_audio_buffer_cleared:            return RealtimeOutputAudioBufferClearedEvent.type
        // MCP
        case .mcp_list_tool_in_progress:              return RealtimeMcpListToolsInProgressEvent.type
        case .mcp_list_tool_completed:                return RealtimeMcpListToolsCompletedEvent.type
        case .mcp_list_tool_failed:                   return RealtimeMcpListToolsFailedEvent.type
        case .mcp_call_in_progress:                   return RealtimeResponseMcpCallInProgressEvent.type
        case .mcp_call_completed:                     return RealtimeResponseMcpCallCompletedEvent.type
        case .mcp_call_failed:                        return RealtimeResponseMcpCallFailedEvent.type
        // Extension OpenAI
        case .unkowned(let event):                    return event.type
        }
    }
}

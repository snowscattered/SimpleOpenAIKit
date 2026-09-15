//
//  ResponseStreamResult.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@BaseModelWithExtra
public struct UnknownEvent {
    public var type: String
}

// ResponseStreamResult
@CodableByConstant(defaultCase: "unkowned")
@nonexhaustive
public enum ResponseStreamResult {
    // State
    case response_created(ResponseCreatedEvent)
    case response_in_progress(ResponseInProgressEvent)
    case response_completed(ResponseCompletedEvent)
    case response_failed(ResponseFailedEvent)
    case response_incomplete(ResponseIncompleteEvent)
    case response_error(ResponseErrorEvent)
    // Content/Item Part
    case response_content_part_added(ResponseContentPartAddedEvent)
    case response_content_part_done(ResponseContentPartDoneEvent)
    case response_output_item_added(ResponseOutputItemAddedEvent)
    case response_output_item_done(ResponseOutputItemDoneEvent)
    // Tool
    case response_custom_tool_call_input_delta(ResponseCustomToolCallInputDeltaEvent)
    case response_custom_tool_call_input_done(ResponseCustomToolCallInputDoneEvent)
    case response_function_call_arguments_delta(ResponseFunctionCallArgumentsDeltaEvent)
    case response_function_call_arguments_done(ResponseFunctionCallArgumentsDoneEvent)
    case response_web_search_call_in_progress(ResponseWebSearchCallInProgressEvent)
    case response_web_search_call_searching(ResponseWebSearchCallSearchingEvent)
    case response_web_search_call_completed(ResponseWebSearchCallCompletedEvent)
    // Audio
    case response_audio_delta(ResponseAudioDeltaEvent)
    case response_audio_done(ResponseAudioDoneEvent)
    case response_audio_transcript_delta(ResponseAudioTranscriptDeltaEvent)
    case response_audio_transcript_done(ResponseAudioTranscriptDoneEvent)
    // Text
    case response_reasoning_summary_part_added(ResponseReasoningSummaryPartAddedEvent)
    case response_reasoning_summary_part_done(ResponseReasoningSummaryPartDoneEvent)
    case response_reasoning_summary_text_delta(ResponseReasoningSummaryTextDeltaEvent)
    case response_reasoning_summary_text_done(ResponseReasoningSummaryTextDoneEvent)
    case response_reasoning_text_delta(ResponseReasoningTextDeltaEvent)
    case response_reasoning_text_done(ResponseReasoningTextDoneEvent)
    case response_refusal_delta(ResponseRefusalDeltaEvent)
    case response_refusal_done(ResponseRefusalDoneEvent)
    case response_output_text_delta(ResponseTextDeltaEvent)
    case response_output_text_done(ResponseTextDoneEvent)
    // Extension OpenAI
    case unkowned(UnknownEvent)
}

extension ResponseStreamResult {
    var type: String {
        switch self {
        // State
        case .response_created:                       return ResponseCreatedEvent.type
        case .response_in_progress:                   return ResponseInProgressEvent.type
        case .response_completed:                     return ResponseCompletedEvent.type
        case .response_failed:                        return ResponseFailedEvent.type
        case .response_incomplete:                    return ResponseIncompleteEvent.type
        case .response_error:                         return ResponseErrorEvent.type
        // Content/Item Part
        case .response_content_part_added:            return ResponseContentPartAddedEvent.type
        case .response_content_part_done:             return ResponseContentPartDoneEvent.type
        case .response_output_item_added:             return ResponseOutputItemAddedEvent.type
        case .response_output_item_done:              return ResponseOutputItemDoneEvent.type
        // Tool
        case .response_custom_tool_call_input_delta:  return ResponseCustomToolCallInputDeltaEvent.type
        case .response_custom_tool_call_input_done:   return ResponseCustomToolCallInputDoneEvent.type
        case .response_function_call_arguments_delta: return ResponseFunctionCallArgumentsDeltaEvent.type
        case .response_function_call_arguments_done:  return ResponseFunctionCallArgumentsDoneEvent.type
        case .response_web_search_call_in_progress:   return ResponseWebSearchCallInProgressEvent.type
        case .response_web_search_call_searching:     return ResponseWebSearchCallSearchingEvent.type
        case .response_web_search_call_completed:     return ResponseWebSearchCallCompletedEvent.type
        // Audio
        case .response_audio_delta:                   return ResponseAudioDeltaEvent.type
        case .response_audio_done:                    return ResponseAudioDoneEvent.type
        case .response_audio_transcript_delta:        return ResponseAudioTranscriptDeltaEvent.type
        case .response_audio_transcript_done:         return ResponseAudioTranscriptDoneEvent.type
        // Text
        case .response_reasoning_summary_part_added:  return ResponseReasoningSummaryPartAddedEvent.type
        case .response_reasoning_summary_part_done:   return ResponseReasoningSummaryPartDoneEvent.type
        case .response_reasoning_summary_text_delta:  return ResponseReasoningSummaryTextDeltaEvent.type
        case .response_reasoning_summary_text_done:   return ResponseReasoningSummaryTextDoneEvent.type
        case .response_reasoning_text_delta:          return ResponseReasoningTextDeltaEvent.type
        case .response_reasoning_text_done:           return ResponseReasoningTextDoneEvent.type
        case .response_refusal_delta:                 return ResponseRefusalDeltaEvent.type
        case .response_refusal_done:                  return ResponseRefusalDoneEvent.type
        case .response_output_text_delta:             return ResponseTextDeltaEvent.type
        case .response_output_text_done:              return ResponseTextDoneEvent.type
        case .unkowned(let event):                    return event.type
        }
    }
}

//
//  AudioTranscriptionsAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public extension OpenAIAsyncAPIResource.AudioTranscriptionsAsyncResource {
    /// Transcribe or translate an uploaded audio file.
    func create(
        parameters: AudioTranscriptionParameters,
        requestOptions: RequestOptions? = nil
    ) async throws -> AudioTranscriptionCreateResult {
        let url = try clientOption.getServerUrl(path: "/audio/transcriptions")
        var nostreamingParameters = parameters
        nostreamingParameters.stream = false
        return try await OpenAISession.shared.AsyncResponse(
            url,
            payload: nostreamingParameters,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .post
        )
    }

    /// Transcribe audio and iterate partial hypotheses as they are produced.
    func stream(
        parameters: AudioTranscriptionParameters,
        requestOptions: RequestOptions? = nil
    ) async throws -> AsyncThrowingStream<AudioTranscriptionStreamResult, any Error> {
        let url = try clientOption.getServerUrl(path: "/audio/transcriptions")
        var streamingParameters = parameters
        streamingParameters.stream = true
        return try await OpenAISession.shared.AsyncStreamResponse(
            url,
            payload: streamingParameters,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .post
        )
    }
}

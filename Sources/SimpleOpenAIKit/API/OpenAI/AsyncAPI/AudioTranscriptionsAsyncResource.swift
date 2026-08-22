//
//  AudioTranscriptionsAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public extension OpenAIAsyncAPIResource.AudioTranscriptionsAsyncResource {
    func create(
        parameters: AudioTranscriptionParameters,
        requestOptions: RequestOptions? = nil
    ) async throws -> AudioTranscriptionCreateResult {
        let url = try client.getServerUrl(path: "/audio/transcriptions")
        var nostreamingParameters = parameters
        nostreamingParameters.stream = false
        return try await OpenAISession.shared.AsyncResponse(
            url,
            payload: nostreamingParameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post
        )
    }

    func stream(
        parameters: AudioTranscriptionParameters,
        requestOptions: RequestOptions? = nil
    ) async throws -> AsyncThrowingStream<AudioTranscriptionStreamResult, Error> {
        let url = try client.getServerUrl(path: "/audio/transcriptions")
        var streamingParameters = parameters
        streamingParameters.stream = true
        return try await OpenAISession.shared.AsyncStreamResponse(
            url,
            payload: streamingParameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post
        )
    }
}

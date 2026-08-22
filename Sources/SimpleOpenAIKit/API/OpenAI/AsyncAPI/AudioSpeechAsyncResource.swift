//
//  AudioSpeechAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public extension OpenAIAsyncAPIResource.AudioSpeechAsyncResource {
    func create(
        parameters: AudioSpeechParameters,
        requestOptions: RequestOptions? = nil
    ) async throws -> Data {
        let url = try client.getServerUrl(path: "/audio/speech")
        var options = requestOptions ?? RequestOptions()
        if options.extra_headers["Accept"] == nil {
            options.extra_headers["Accept"] = "application/octet-stream"
        }
        return try await OpenAISession.shared.AsyncResponse(
            url,
            payload: parameters,
            requestOptions: options,
            client: self.client,
            method: .post
        )
    }
    func stream(
        parameters: AudioSpeechParameters,
        requestOptions: RequestOptions? = nil
    ) async throws -> AsyncThrowingStream<Data, Error> {
        let url = try client.getServerUrl(path: "/audio/speech")
        var options = requestOptions ?? RequestOptions()
        if options.extra_headers["Accept"] == nil {
            options.extra_headers["Accept"] = "application/octet-stream"
        }
        return try await OpenAISession.shared.AsyncStreamResponse(
            url,
            payload: parameters,
            requestOptions: options,
            client: self.client,
            method: .post
        )
    }
}

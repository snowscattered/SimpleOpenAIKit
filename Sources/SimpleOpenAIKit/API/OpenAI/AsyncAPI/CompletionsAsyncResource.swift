//
//  CompletionsAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/8/26.
//

import Foundation

public extension OpenAIAsyncAPIResource.CompletionsAsyncResource {
    func create(parameters: CompletionParameters, requestOptions: RequestOptions? = nil) async throws -> CompletionCreateResult {
        let url = try clientOption.getServerUrl(path: "/completions")
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
    func stream(parameters: CompletionParameters, requestOptions: RequestOptions? = nil) async throws -> AsyncThrowingStream<CompletionCreateResult, Error> {
        let url = try clientOption.getServerUrl(path: "/completions")
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

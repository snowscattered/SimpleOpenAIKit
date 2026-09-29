//
//  AnthropicCompletionsAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public extension AnthropicAsyncAPIResource.CompletionsAsyncResource {
    /// Send a legacy completion request and wait for the whole result.
    func create(parameters: CompletionParameters, requestOptions: RequestOptions? = nil) async throws -> CompletionCreateResult {
        let url = try clientOption.getServerUrl(path: "/completions")
        var nostreamingParameters = parameters
        nostreamingParameters.stream = false
        return try await AnthropicSession.shared.AsyncResponse(
            url,
            payload: nostreamingParameters,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .post
        )
    }
    /// Send a legacy completion request with `stream` enabled and iterate the chunks.
    func stream(parameters: CompletionParameters, requestOptions: RequestOptions? = nil) async throws -> AsyncThrowingStream<CompletionCreateResult, any Error> {
        let url = try clientOption.getServerUrl(path: "/completions")
        var streamingParameters = parameters
        streamingParameters.stream = true
        return try await AnthropicSession.shared.AsyncStreamResponse(
            url,
            payload: streamingParameters,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .post
        )
    }
}

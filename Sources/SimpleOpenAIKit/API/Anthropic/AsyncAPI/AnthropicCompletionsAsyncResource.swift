//
//  AnthropicCompletionsAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public extension AnthropicAsyncAPIResource.CompletionsAsyncResource {
    func create(parameters: CompletionParameters, requestOptions: RequestOptions? = nil) async throws -> CompletionCreateResult {
        let url = try client.getServerUrl(path: "/completions")
        var nostreamingParameters = parameters
        nostreamingParameters.stream = false
        return try await AnthropicSession.shared.AsyncResponse(
            url,
            payload: nostreamingParameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post
        )
    }
    func stream(parameters: CompletionParameters, requestOptions: RequestOptions? = nil) async throws -> AsyncThrowingStream<CompletionCreateResult, Error> {
        let url = try client.getServerUrl(path: "/completions")
        var streamingParameters = parameters
        streamingParameters.stream = true
        return try await AnthropicSession.shared.AsyncStreamResponse(
            url,
            payload: streamingParameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post
        )
    }
}

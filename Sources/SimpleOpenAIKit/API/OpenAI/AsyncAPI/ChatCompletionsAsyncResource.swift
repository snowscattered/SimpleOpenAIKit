//
//  ChatCompletionsAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/8/26.
//

import Foundation

public extension OpenAIAsyncAPIResource.ChatCompletionsAsyncResource {
    func create(parameters: ChatParameters, requestOptions: RequestOptions? = nil) async throws -> ChatCreateResult {
        let url = try client.getServerUrl(path: "/chat/completions")
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
    func stream(parameters: ChatParameters, requestOptions: RequestOptions? = nil) async throws -> AsyncThrowingStream<ChatStreamResult, Error> {
        let url = try client.getServerUrl(path: "/chat/completions")
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

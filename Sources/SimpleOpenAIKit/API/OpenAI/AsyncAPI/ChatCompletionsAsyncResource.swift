//
//  ChatCompletionsAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/8/26.
//

import Foundation

public extension OpenAIAsyncAPIResource.ChatCompletionsAsyncResource {
    /// Send a chat request and wait for the whole answer.
    func create(parameters: ChatParameters, requestOptions: RequestOptions? = nil) async throws -> ChatCreateResult {
        let url = try clientOption.getServerUrl(path: "/chat/completions")
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
    /// Send a chat request with `stream` enabled and iterate `ChatStreamResult` chunks.
    func stream(parameters: ChatParameters, requestOptions: RequestOptions? = nil) async throws -> AsyncThrowingStream<ChatStreamResult, any Error> {
        let url = try clientOption.getServerUrl(path: "/chat/completions")
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
    /// Send a chat request whose answer has to fit `parameters.response_format`, and decode it into
    /// that schema. `message.parsed` is `nil` when the answer carries no string content.
    func parse<T: SchemaProtocol>(
        parameters: ChatParseParameters<T>,
        requestOptions: RequestOptions? = nil
    ) async throws -> ChatParseResult<T> {
        let result: ChatCreateResult = try await self.create(
            parameters: parameters.createParameters,
            requestOptions: requestOptions
        )
        return try ChatParseResult(result)
    }
}

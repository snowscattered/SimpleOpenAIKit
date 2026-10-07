//
//  MessagesAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public extension AnthropicAsyncAPIResource.MessagesAsyncResource {
    /// Send a Messages request and wait for the whole reply.
    func create(
        parameters: MessageParameters,
        requestOptions: RequestOptions? = nil
    ) async throws -> MessageCreateResult {
        let url = try clientOption.getServerUrl(path: "/v1/messages")
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

    /// Send a Messages request with `stream` enabled and iterate the SSE events.
    func stream(
        parameters: MessageParameters,
        requestOptions: RequestOptions? = nil
    ) async throws -> AsyncThrowingStream<MessageStreamResult, any Error> {
        let url = try clientOption.getServerUrl(path: "/v1/messages")
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

    // MARK: Structured Outputs
    /// Send a Messages request whose answer has to fit `parameters.output_format`, and decode it into
    /// that schema. `textBlock.parsed` is `nil` when the answer carries no text.
    func parse<T: SchemaProtocol>(
        parameters: MessageParseParameters<T>,
        requestOptions: RequestOptions? = nil
    ) async throws -> MessageParseResult<T> {
        let result: MessageCreateResult = try await self.create(
            parameters: parameters.createParameters,
            requestOptions: requestOptions
        )
        return try MessageParseResult(result)
    }
    
    /// Estimate the input tokens of a Messages payload without generating output.
    func count_tokens(
        parameters: MessageCountTokenParameters,
        requestOptions: RequestOptions? = nil
    ) async throws -> MessageCreateResult {
        let url = try clientOption.getServerUrl(path: "/v1/messages/count_tokens")
        return try await AnthropicSession.shared.AsyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .post
        )
    }
}

//
//  MessagesAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public extension AnthropicAsyncAPIResource.MessagesAsyncResource {
    func create(
        parameters: MessageParameters,
        requestOptions: RequestOptions? = nil
    ) async throws -> MessageCreateResult {
        let url = try client.getServerUrl(path: "/v1/messages")
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

    func stream(
        parameters: MessageParameters,
        requestOptions: RequestOptions? = nil
    ) async throws -> AsyncThrowingStream<MessageStreamResult, Error> {
        let url = try client.getServerUrl(path: "/v1/messages")
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
    
    func count_tokens(
        parameters: MessageCountTokenParameters,
        requestOptions: RequestOptions? = nil
    ) async throws -> MessageCreateResult {
        let url = try client.getServerUrl(path: "/v1/messages/count_tokens")
        return try await AnthropicSession.shared.AsyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post
        )
    }
}

//
//  MessagesSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public extension AnthropicSyncAPIResource.MessagesSyncResource {
    /// Send a Messages request and wait for the whole reply.
    func create(
        parameters: MessageParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> MessageCreateResult {
        let url = try clientOption.getServerUrl(path: "/v1/messages")
        var nostreamingParameters = parameters
        nostreamingParameters.stream = false
        return try AnthropicSession.shared.SyncResponse(
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
    ) throws -> SyncThrowingStream<MessageStreamResult, any Error> {
        let url = try clientOption.getServerUrl(path: "/v1/messages")
        var streamingParameters = parameters
        streamingParameters.stream = true
        return try AnthropicSession.shared.SyncStreamResponse(
            url,
            payload: streamingParameters,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .post
        )
    }
    
    /// Estimate the input tokens of a Messages payload without generating output.
    func count_tokens(
        parameters: MessageCountTokenParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> MessageCreateResult {
        let url = try clientOption.getServerUrl(path: "/v1/messages/count_tokens")
        return try AnthropicSession.shared.SyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .post
        )
    }
}

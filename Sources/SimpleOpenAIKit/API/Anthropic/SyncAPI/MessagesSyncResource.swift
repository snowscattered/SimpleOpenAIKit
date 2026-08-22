//
//  MessagesSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public extension AnthropicSyncAPIResource.MessagesSyncResource {
    func create(
        parameters: MessageParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> MessageCreateResult {
        let url = try client.getServerUrl(path: "/v1/messages")
        var nostreamingParameters = parameters
        nostreamingParameters.stream = false
        return try AnthropicSession.shared.SyncResponse(
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
    ) throws -> SyncThrowingStream<MessageStreamResult, Error> {
        let url = try client.getServerUrl(path: "/v1/messages")
        var streamingParameters = parameters
        streamingParameters.stream = true
        return try AnthropicSession.shared.SyncStreamResponse(
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
    ) throws -> MessageCreateResult {
        let url = try client.getServerUrl(path: "/v1/messages/count_tokens")
        return try AnthropicSession.shared.SyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post
        )
    }
}

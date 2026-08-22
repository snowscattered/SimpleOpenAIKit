//
//  ChatCompletionsSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/8/26.
//

import Foundation

public extension OpenAISyncAPIResource.ChatCompletionsSyncResource {
    func create(
        parameters: ChatParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> ChatCreateResult {
        let url = try client.getServerUrl(path: "/chat/completions")
        var nostreamingParameters = parameters
        nostreamingParameters.stream = false
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: nostreamingParameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post
        )
    }
    
    func stream(
        parameters: ChatParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> SyncThrowingStream<ChatStreamResult, Error> {
        let url = try client.getServerUrl(path: "/chat/completions")
        var streamingParameters = parameters
        streamingParameters.stream = true
        return try OpenAISession.shared.SyncStreamResponse(
            url,
            payload: streamingParameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post
        )
    }
}

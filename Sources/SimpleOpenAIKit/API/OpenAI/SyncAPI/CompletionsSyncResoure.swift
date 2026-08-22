//
//  CompletionsSyncResoure.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/8/26.
//

import Foundation

public extension OpenAISyncAPIResource.CompletionsSyncResource {
    func create(
        parameters: CompletionParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> CompletionCreateResult {
        let url = try client.getServerUrl(path: "/completions")
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
        parameters: CompletionParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> SyncThrowingStream<CompletionCreateResult, Error> {
        let url = try client.getServerUrl(path: "/completions")
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

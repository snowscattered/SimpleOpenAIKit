//
//  AnthropicCompletionsSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/13/26.
//

import Foundation

public extension AnthropicSyncAPIResource.CompletionsSyncResource {
    func create(parameters: CompletionParameters, requestOptions: RequestOptions? = nil) throws -> CompletionCreateResult {
        let url = try clientOption.getServerUrl(path: "/completions")
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
    func stream(parameters: CompletionParameters, requestOptions: RequestOptions? = nil) throws -> SyncThrowingStream<CompletionCreateResult, Error> {
        let url = try clientOption.getServerUrl(path: "/completions")
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
}

//
//  EmbeddingsAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public extension OpenAIAsyncAPIResource.EmbeddingsAsyncResource {
    func create(
        parameters: EmbeddingParameters,
        requestOptions: RequestOptions? = nil
    ) async throws -> EmbeddingCreateResult {
        let url = try client.getServerUrl(path: "/embeddings")
        return try await OpenAISession.shared.AsyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post
        )
    }
}

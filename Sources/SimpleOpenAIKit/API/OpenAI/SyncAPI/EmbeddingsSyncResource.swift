//
//  EmbeddingsSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public extension OpenAISyncAPIResource.EmbeddingsSyncResource {
    func create(
        parameters: EmbeddingParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> EmbeddingCreateResult {
        let url = try clientOption.getServerUrl(path: "/embeddings")
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .post
        )
    }
}

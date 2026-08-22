//
//  ModelsAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public extension OpenAIAsyncAPIResource.ModelsAsyncResource {
    func list(
        requestOptions: RequestOptions? = nil
    ) async throws -> PageStruct<ModelResult> {
        let url = try client.getServerUrl(path: "/models")
        return try await OpenAISession.shared.AsyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            client: self.client,
            method: .get
        )
    }
    func retrieve(
        model: String,
        requestOptions: RequestOptions? = nil
    ) async throws -> ModelResult {
        let url = try client.getServerUrl(path: "/models/\(model)")
        return try await OpenAISession.shared.AsyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            client: self.client,
            method: .get
        )
    }
    func delete(
        model: String,
        requestOptions: RequestOptions? = nil
    ) async throws -> ModelDeletedResult {
        let url = try client.getServerUrl(path: "/models/\(model)")
        return try await OpenAISession.shared.AsyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            client: self.client,
            method: .delete
        )
    }
}

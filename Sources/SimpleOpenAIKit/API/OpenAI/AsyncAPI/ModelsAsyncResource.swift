//
//  ModelsAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public extension OpenAIAsyncAPIResource.ModelsAsyncResource {
    /// List every model the key can reach, in one page.
    func list(
        requestOptions: RequestOptions? = nil
    ) async throws -> PageStruct<ModelResult> {
        let url = try clientOption.getServerUrl(path: "/models")
        return try await OpenAISession.shared.AsyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .get
        )
    }
    /// Fetch one model's metadata.
    func retrieve(
        model: String,
        requestOptions: RequestOptions? = nil
    ) async throws -> ModelResult {
        let url = try clientOption.getServerUrl(path: "/models/\(model)")
        return try await OpenAISession.shared.AsyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .get
        )
    }
    /// Delete a fine-tuned model.
    func delete(
        model: String,
        requestOptions: RequestOptions? = nil
    ) async throws -> ModelDeletedResult {
        let url = try clientOption.getServerUrl(path: "/models/\(model)")
        return try await OpenAISession.shared.AsyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .delete
        )
    }
}

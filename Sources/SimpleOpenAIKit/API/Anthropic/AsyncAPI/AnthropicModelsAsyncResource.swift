//
//  AnthropicModelsAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public extension AnthropicAsyncAPIResource.ModelsAsyncResource {
    /// Iterate the available models, requesting the next page with the `after_id` cursor.
    func list(
        after_id: String? = nil,
        before_id: String? = nil,
        limit: Int? = nil,
        requestOptions: RequestOptions? = nil
    ) async throws -> AsyncThrowingPages<Query?, ModelResult> {
        let url = try clientOption.getServerUrl(path: "/models")
        var parameters: Query = [:]
        if let after_id { parameters["after_id"] = .string(after_id) }
        if let before_id { parameters["before_id"] = .string(before_id) }
        if let limit { parameters["limit"] = .int(limit) }
        return try await AsyncThrowingPages(parameters: parameters) { [clientOption] parameters in
            let result: AsyncThrowingPages<Query?, ModelResult> = try await AnthropicSession.shared.AsyncResponse(
                url,
                payload: parameters,
                requestOptions: requestOptions,
                clientOption: clientOption,
                method: .get
            )
            guard var next = parameters else { return (page: result, next: nil) }
            if parameters?["before_id"] != nil {
                guard let before_id = result.extra["before_id"] else { return (page: result, next: nil) }
                next["before_id"] = before_id
                next["after_id"] = nil
            } else {
                guard let after_id = result.extra["after_id"] else { return (page: result, next: nil) }
                next["after_id"] = after_id
                next["before_id"] = nil
            }
            return (page: result, next: next)
        }
    }
    /// Fetch one model's metadata.
    func retrieve(
        model: String,
        requestOptions: RequestOptions? = nil
    ) async throws -> ModelResult {
        let url = try clientOption.getServerUrl(path: "/models/\(model)")
        return try await AnthropicSession.shared.AsyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .get
        )
    }
}

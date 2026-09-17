//
//  AnthropicModelsAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public extension AnthropicAsyncAPIResource.ModelsAsyncResource {
    func list(
        requestOptions: RequestOptions? = nil,
        after_id: String? = nil,
        before_id: String? = nil,
        limit: Int? = nil
    ) async throws -> AsyncThrowingPages<ModelResult> {
        let url = try clientOption.getServerUrl(path: "/models")
        var currentAfter = after_id
        return AsyncThrowingPages {
            var payload: [String: Any] = [:]
            if let currentAfter { payload["after_id"] = currentAfter }
            if let before_id { payload["before_id"] = before_id }
            if let limit { payload["limit"] = limit }
            let result: PageStruct<ModelResult> = try await AnthropicSession.shared.AsyncResponse(
                url,
                payload: try JSONSerialization.data(withJSONObject: payload),
                requestOptions: requestOptions,
                clientOption: self.clientOption,
                method: .get
            )
            if let last = result.data.last {
                currentAfter = last.id
            }
            return result
        }
    }
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

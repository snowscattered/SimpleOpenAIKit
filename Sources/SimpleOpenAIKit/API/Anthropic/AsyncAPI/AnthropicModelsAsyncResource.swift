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
        after_id: String?,
        before_id: String?,
        limit: Int?
    ) async throws -> PageStruct<ModelResult> {
        let url = try client.getServerUrl(path: "/models")
        var payload: [String: Any] = [:]
        if let after_id { payload["after_id"] = after_id }
        if let before_id { payload["before_id"] = before_id }
        if let limit { payload["limit"] = limit }
        return try await AnthropicSession.shared.AsyncResponse(
            url,
            payload: try JSONSerialization.data(withJSONObject: payload),
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
        return try await AnthropicSession.shared.AsyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            client: self.client,
            method: .get
        )
    }
}

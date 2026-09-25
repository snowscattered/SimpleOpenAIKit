//
//  TypeSafeModelsAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Foundation

public extension TypeSafeAsyncAPIResource.ModelsAsyncResource {
    func list(
        requestOptions: RequestOptions? = nil
    ) async throws -> TypeSafeModelListResult {
        let url = try clientOption.getServerUrl(path: "/v1/models")
        return try await TypeSafeSession.shared.AsyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .get
        )
    }
}

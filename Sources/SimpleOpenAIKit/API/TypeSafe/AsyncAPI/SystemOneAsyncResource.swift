//
//  SystemOneAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Foundation

public extension TypeSafeAsyncAPIResource.SystemOneAsyncResource {
    /// Ask System One for its judgements, defaulting the model to the client's configured one.
    func system_one(
        parameters: SystemOneParameters,
        requestOptions: RequestOptions? = nil
    ) async throws -> SystemOneResult {
        var parameters = parameters
        if parameters.model == nil {
            parameters.model = clientOption.model
        }
        let url = try clientOption.getServerUrl(path: "/v1/systemone")
        return try await TypeSafeSession.shared.AsyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .post
        )
    }
}

public extension AsyncTypeSafeClient {
    /// Convenience wrapper around the client's internal `systemOne` resource.
    func system_one(
        parameters: SystemOneParameters,
        requestOptions: RequestOptions? = nil
    ) async throws -> SystemOneResult {
        try await systemOne.system_one(parameters: parameters, requestOptions: requestOptions)
    }
}

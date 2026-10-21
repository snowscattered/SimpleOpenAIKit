//
//  SystemOneAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Foundation

public extension TypeSafeAsyncAPIResource.SystemOneAsyncResource {
    func system_one<Response: Decodable & Sendable>(
        parameters: SystemOneParameters,
        response_model: Response.Type = SystemOneResult.self,
        requestOptions: RequestOptions? = nil
    ) async throws -> Response {
        var parameters = parameters
        if parameters.model == nil {
            parameters.model = clientOption.model
        }
        let url = try clientOption.getServerUrl(path: "/v1/systemone")
        let hasFile = parameters.assets?.values.contains { $0.file != nil } ?? false
        return try await TypeSafeSession.shared.AsyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .post,
            hasFile: hasFile
        )
    }
}

public extension AsyncTypeSafeClient {
    func system_one<Response: Decodable & Sendable>(
        parameters: SystemOneParameters,
        response_model: Response.Type = SystemOneResult.self,
        requestOptions: RequestOptions? = nil
    ) async throws -> Response {
        try await systemOne.system_one(
            parameters: parameters,
            response_model: response_model,
            requestOptions: requestOptions
        )
    }
}

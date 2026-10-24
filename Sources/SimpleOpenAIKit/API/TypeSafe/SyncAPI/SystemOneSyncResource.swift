//
//  SystemOneSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Foundation

public extension TypeSafeSyncAPIResource.SystemOneSyncResource {
    /// Ask System One for its judgements and decode the response into a caller-defined model.
    func system_one<Response: Decodable & Sendable>(
        parameters: SystemOneParameters,
        response_model: Response.Type = SystemOneResult.self,
        requestOptions: RequestOptions? = nil
    ) throws -> Response {
        var parameters = parameters
        var requestOptions = requestOptions
        if parameters.model == nil {
            parameters.model = clientOption.model
        }
        let url = try clientOption.getServerUrl(path: "/v1/systemone")
        let hasFile = parameters.assets?.values.contains { $0.file != nil } ?? false
        parameters.extra = parameters.extra | (requestOptions?.extra_body ?? [:])
        requestOptions?.extra_body = [:]
        return try TypeSafeSession.shared.SyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .post,
            hasFile: hasFile
        )
    }
}

public extension TypeSafeClient {
    /// Convenience wrapper for decoding into a caller-defined response model.
    func system_one<Response: Decodable & Sendable>(
        parameters: SystemOneParameters,
        response_model: Response.Type = SystemOneResult.self,
        requestOptions: RequestOptions? = nil
    ) throws -> Response {
        try systemOne.system_one(
            parameters: parameters,
            response_model: response_model,
            requestOptions: requestOptions
        )
    }
}

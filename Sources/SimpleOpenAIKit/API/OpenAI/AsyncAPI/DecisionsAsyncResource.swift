//
//  DecisionsAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/10/7.
//

import Foundation

public extension OpenAIAsyncAPIResource.DecisionsAsyncResource {
    func create(
        parameters: DecisionCreateParameters,
        requestOptions: RequestOptions? = nil
    ) async throws -> DecisionResult {
        let url = try clientOption.getServerUrl(path: "/decisions")
        return try await OpenAISession.shared.AsyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .post
        )
    }
}

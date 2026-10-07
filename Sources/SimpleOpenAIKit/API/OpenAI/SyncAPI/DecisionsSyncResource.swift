//
//  DecisionsSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/10/7.
//

import Foundation

public extension OpenAISyncAPIResource.DecisionsSyncResource {
    func create(
        parameters: DecisionCreateParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> DecisionResult {
        let url = try clientOption.getServerUrl(path: "/decisions")
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .post
        )
    }
}

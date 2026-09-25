//
//  SystemOneSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Foundation

public extension TypeSafeSyncAPIResource.SystemOneSyncResource {
    func system_one(
        parameters: SystemOneParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> SystemOneResult {
        var parameters = parameters
        if parameters.model == nil {
            parameters.model = clientOption.model
        }
        let url = try clientOption.getServerUrl(path: "/v1/systemone")
        return try TypeSafeSession.shared.SyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .post
        )
    }
}

public extension TypeSafeClient {
    func system_one(
        parameters: SystemOneParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> SystemOneResult {
        try systemOne.system_one(parameters: parameters, requestOptions: requestOptions)
    }
}

//
//  TypeSafeModelsSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Foundation

public extension TypeSafeSyncAPIResource.ModelsSyncResource {
    func list(
        requestOptions: RequestOptions? = nil
    ) throws -> TypeSafeModelListResult {
        let url = try clientOption.getServerUrl(path: "/v1/models")
        return try TypeSafeSession.shared.SyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .get
        )
    }
}

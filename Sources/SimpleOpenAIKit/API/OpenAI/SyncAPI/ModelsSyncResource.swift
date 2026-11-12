//
//  ModelsSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public extension OpenAISyncAPIResource.ModelsSyncResource {
    /// List every model the key can reach, in one page.
    func list(
        requestOptions: RequestOptions? = nil
    ) throws -> SyncThrowingPages<String?, ModelResult> {
        let url = try clientOption.getServerUrl(path: "/models")
        return try SyncThrowingPages(parameters: nil) { [clientOption] parameters in
            let result: SyncThrowingPages<String?, ModelResult> = try OpenAISession.shared.SyncResponse(
                url,
                payload: nil as String?,
                requestOptions: requestOptions,
                clientOption: clientOption,
                method: .get
            )
            return (page: result, next: nil)
        }
    }

    /// Fetch one model's metadata.
    func retrieve(
        model: String,
        requestOptions: RequestOptions? = nil
    ) throws -> ModelResult {
        let url = try clientOption.getServerUrl(path: "/models/\(model)")
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .get
        )
    }
    /// Delete a fine-tuned model.
    func delete(
        model: String,
        requestOptions: RequestOptions? = nil
    ) throws -> ModelDeletedResult {
        let url = try clientOption.getServerUrl(path: "/models/\(model)")
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .delete
        )
    }
}

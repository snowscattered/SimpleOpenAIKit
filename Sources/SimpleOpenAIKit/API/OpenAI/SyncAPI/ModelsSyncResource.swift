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
    ) throws -> PageStruct<ModelResult> {
        let url = try clientOption.getServerUrl(path: "/models")
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .get
        )
    }
//    func list(
//        requestOptions: RequestOptions? = nil
//    ) throws -> SyncThrowingPages<ModelResult> {
//        let url = try client.getServerUrl(path: "/models")
//        return SyncThrowingPages {
//            try OpenAISession.shared.SyncResponse(
//                url,
//                payload: nil as String?,
//                requestOptions: requestOptions,
//                client: self.client,
//                method: .get
//            )
//        }
//    }
    
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

//
//  ModelsSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public extension OpenAISyncAPIResource.ModelsSyncResource {
    func list(
        requestOptions: RequestOptions? = nil
    ) throws -> PageStruct<ModelResult> {
        let url = try client.getServerUrl(path: "/models")
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            client: self.client,
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
    
    func retrieve(
        model: String,
        requestOptions: RequestOptions? = nil
    ) throws -> ModelResult {
        let url = try client.getServerUrl(path: "/models/\(model)")
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            client: self.client,
            method: .get
        )
    }
    func delete(
        model: String,
        requestOptions: RequestOptions? = nil
    ) throws -> ModelDeletedResult {
        let url = try client.getServerUrl(path: "/models/\(model)")
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            client: self.client,
            method: .delete
        )
    }
}

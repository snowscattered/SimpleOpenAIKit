//
//  FilesSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/13/26.
//

import Foundation

public extension OpenAISyncAPIResource.FilesSyncResource {
    func create(
        parameters: FilesCreateParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> FileResult {
        let url = try clientOption.getServerUrl(path: "/files")
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .post,
            hasFile: true
        )
    }
    func list(
        parameters: FilesListParameters? = nil,
        requestOptions: RequestOptions? = nil
    ) throws -> SyncThrowingPages<FileResult> {
        let url = try clientOption.getServerUrl(path: "/files")
        var nextAfter = parameters?.after
        var currentParams = parameters ?? FilesListParameters()
        return SyncThrowingPages {
            currentParams.after = nextAfter
            let result: PageStruct<FileResult> = try OpenAISession.shared.SyncResponse(
                url,
                payload: currentParams,
                requestOptions: requestOptions,
                clientOption: self.clientOption,
                method: .get
            )
            if let last = result.data.last {
                nextAfter = last.id
            }
            return result
        }
    }
    func retrieve(
        file_id: String,
        requestOptions: RequestOptions? = nil
    ) throws -> FileResult {
        let url = try clientOption.getServerUrl(path: "/files/\(file_id)")
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .get
        )
    }
    func delete(
        file_id: String,
        requestOptions: RequestOptions? = nil
    ) throws -> FileDeleted {
        let url = try clientOption.getServerUrl(path: "/files/\(file_id)")
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .delete
        )
    }
}

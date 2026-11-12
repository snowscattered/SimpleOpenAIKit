//
//  FilesSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/13/26.
//

import Foundation

public extension OpenAISyncAPIResource.FilesSyncResource {
    /// Upload a file for use by another endpoint.
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
    /// Iterate the files stored under the account, one page per request.
    func list(
        parameters: FilesListParameters? = nil,
        requestOptions: RequestOptions? = nil
    ) throws -> SyncThrowingPages<FilesListParameters, FileResult> {
        let url = try clientOption.getServerUrl(path: "/files")
        return try SyncThrowingPages(parameters: parameters ?? FilesListParameters()) { [clientOption] parameters in
            let result: SyncThrowingPages<FilesListParameters, FileResult> = try OpenAISession.shared.SyncResponse(
                url,
                payload: parameters,
                requestOptions: requestOptions,
                clientOption: clientOption,
                method: .get
            )
            var next = parameters
            if let last = result.data.last { next.after = last.id }
            return (page: result, next: next)
        }
    }
    /// Fetch one file's metadata.
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
    /// Delete a stored file.
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

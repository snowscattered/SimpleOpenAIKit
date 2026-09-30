//
//  FilesAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/17/26.
//

import Foundation

public extension OpenAIAsyncAPIResource.FilesAsyncResource {
    /// Upload a file for use by another endpoint.
    func create(
        parameters: FilesCreateParameters,
        requestOptions: RequestOptions? = nil
    ) async throws -> FileResult {
        let url = try clientOption.getServerUrl(path: "/files")
        return try await OpenAISession.shared.AsyncResponse(
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
    ) async throws -> AsyncThrowingPages<FileResult> {
        let url = try clientOption.getServerUrl(path: "/files")
        var currentParams = parameters ?? FilesListParameters()
        var nextAfter = parameters?.after
        return AsyncThrowingPages { [clientOption] in
            currentParams.after = nextAfter
            let result: PageStruct<FileResult> = try await OpenAISession.shared.AsyncResponse(
                url,
                payload: currentParams,
                requestOptions: requestOptions,
                clientOption: clientOption,
                method: .get
            )
            if let last = result.data.last {
                nextAfter = last.id
            }
            return result
        }
    }
    /// Fetch one file's metadata.
    func retrieve(
        file_id: String,
        requestOptions: RequestOptions? = nil
    ) async throws -> FileResult {
        let url = try clientOption.getServerUrl(path: "/files/\(file_id)")
        return try await OpenAISession.shared.AsyncResponse(
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
    ) async throws -> FileDeleted {
        let url = try clientOption.getServerUrl(path: "/files/\(file_id)")
        return try await OpenAISession.shared.AsyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .delete
        )
    }
}

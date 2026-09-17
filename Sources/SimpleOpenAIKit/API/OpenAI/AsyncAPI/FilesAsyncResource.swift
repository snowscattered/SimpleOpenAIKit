//
//  FilesAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/17/26.
//

import Foundation

public extension OpenAIAsyncAPIResource.FilesAsyncResource {
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
    func list(
        parameters: FilesListParameters? = nil,
        requestOptions: RequestOptions? = nil
    ) async throws -> AsyncThrowingPages<FileResult> {
        let url = try clientOption.getServerUrl(path: "/files")
        var nextAfter = parameters?.after
        var currentParams = parameters ?? FilesListParameters()
        return AsyncThrowingPages {
            currentParams.after = nextAfter
            let result: PageStruct<FileResult> = try await OpenAISession.shared.AsyncResponse(
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

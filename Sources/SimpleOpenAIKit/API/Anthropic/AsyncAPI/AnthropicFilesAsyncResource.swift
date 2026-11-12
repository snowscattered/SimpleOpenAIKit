//
//  AnthropicFilesAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/11/11.
//

import Foundation

public extension AnthropicAsyncAPIResource.FilesAsyncResource {
    /// Upload a file and wait for its metadata.
    func create(
        parameters: AnthropicFilesUploadParameters,
        requestOptions: RequestOptions? = nil
    ) async throws -> AnthropicFileResult {
        let url = try clientOption.getServerUrl(path: "/v1/files")
        var options = requestOptions ?? RequestOptions()
        if let workspace_id = parameters.workspace_id {
            options.extra_headers = ["workspace_id": workspace_id] | options.extra_headers
        }
        return try await AnthropicSession.shared.AsyncResponse(
            url,
            payload: parameters,
            requestOptions: options,
            clientOption: self.clientOption,
            method: .post,
            hasFile: true
        )
    }

    /// Iterate files using the `page` returned by each response.
    func list(
        parameters: AnthropicFilesListParameters? = nil,
        requestOptions: RequestOptions? = nil
    ) async throws -> AsyncThrowingPages<AnthropicFilesListParameters, AnthropicFileResult> {
        let url = try clientOption.getServerUrl(path: "/v1/files")
        return try await AsyncThrowingPages(parameters: parameters ?? AnthropicFilesListParameters()) { [clientOption] parameters in
            var options = requestOptions ?? RequestOptions()
            if let workspace_id = parameters.workspace_id {
                options.extra_headers = ["workspace_id": workspace_id] | options.extra_headers
            }
            let result: AsyncThrowingPages<AnthropicFilesListParameters, AnthropicFileResult> = try await AnthropicSession.shared.AsyncResponse(
                url,
                payload: parameters,
                requestOptions: options,
                clientOption: clientOption,
                method: .get
            )
            var next = parameters
            next.page = result.next_page
            return (page: result, next: next)
        }
    }

    /// Fetch one file's metadata.
    func retrieve(
        file_id: String,
        workspace_id: String? = nil,
        requestOptions: RequestOptions? = nil
    ) async throws -> AnthropicFileResult {
        let url = try clientOption.getServerUrl(path: "/v1/files/\(file_id)")
        var options = requestOptions ?? RequestOptions()
        if let workspace_id {
            options.extra_headers = ["workspace_id": workspace_id] | options.extra_headers
        }
        return try await AnthropicSession.shared.AsyncResponse(
            url,
            payload: nil as String?,
            requestOptions: options,
            clientOption: self.clientOption,
            method: .get
        )
    }

    /// Delete a stored file.
    func delete(
        file_id: String,
        workspace_id: String? = nil,
        requestOptions: RequestOptions? = nil
    ) async throws -> AnthropicFileDeletedResult {
        let url = try clientOption.getServerUrl(path: "/v1/files/\(file_id)")
        var options = requestOptions ?? RequestOptions()
        if let workspace_id {
            options.extra_headers = ["workspace_id": workspace_id] | options.extra_headers
        }
        return try await AnthropicSession.shared.AsyncResponse(
            url,
            payload: nil as String?,
            requestOptions: options,
            clientOption: self.clientOption,
            method: .delete
        )
    }

    /// Download a stored file unchanged as raw data.
    func download(
        file_id: String,
        workspace_id: String? = nil,
        requestOptions: RequestOptions? = nil
    ) async throws -> Data {
        let url = try clientOption.getServerUrl(path: "/v1/files/\(file_id)/content")
        var options = requestOptions ?? RequestOptions()
        if let workspace_id {
            options.extra_headers = ["workspace_id": workspace_id] | options.extra_headers
        }
        if options.extra_headers["Accept"] == nil {
            options.extra_headers["Accept"] = "application/octet-stream"
        }
        return try await AnthropicSession.shared.AsyncResponse(
            url,
            payload: nil as String?,
            requestOptions: options,
            clientOption: self.clientOption,
            method: .get
        )
    }
}

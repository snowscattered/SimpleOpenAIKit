//
//  AnthropicFilesSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/11/11.
//

import Foundation

public extension AnthropicSyncAPIResource.FilesSyncResource {
    /// Upload a file and wait for its metadata.
    func create(
        parameters: AnthropicFilesUploadParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> AnthropicFileResult {
        let url = try clientOption.getServerUrl(path: "/v1/files")
        var options = requestOptions ?? RequestOptions()
        if let workspace_id = parameters.workspace_id {
            options.extra_headers = ["workspace_id": workspace_id] | options.extra_headers
        }
        return try AnthropicSession.shared.SyncResponse(
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
    ) throws -> SyncThrowingPages<AnthropicFilesListParameters, AnthropicFileResult> {
        let url = try clientOption.getServerUrl(path: "/v1/files")
        return try SyncThrowingPages(parameters: parameters ?? AnthropicFilesListParameters()) { [clientOption] parameters in
            var options = requestOptions ?? RequestOptions()
            if let workspace_id = parameters.workspace_id {
                options.extra_headers = ["workspace_id": workspace_id] | options.extra_headers
            }
            let result: SyncThrowingPages<AnthropicFilesListParameters, AnthropicFileResult> = try AnthropicSession.shared.SyncResponse(
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
    ) throws -> AnthropicFileResult {
        let url = try clientOption.getServerUrl(path: "/v1/files/\(file_id)")
        var options = requestOptions ?? RequestOptions()
        if let workspace_id {
            options.extra_headers = ["workspace_id": workspace_id] | options.extra_headers
        }
        return try AnthropicSession.shared.SyncResponse(
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
    ) throws -> AnthropicFileDeletedResult {
        let url = try clientOption.getServerUrl(path: "/v1/files/\(file_id)")
        var options = requestOptions ?? RequestOptions()
        if let workspace_id {
            options.extra_headers = ["workspace_id": workspace_id] | options.extra_headers
        }
        return try AnthropicSession.shared.SyncResponse(
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
    ) throws -> Data {
        let url = try clientOption.getServerUrl(path: "/v1/files/\(file_id)/content")
        var options = requestOptions ?? RequestOptions()
        if let workspace_id {
            options.extra_headers = ["workspace_id": workspace_id] | options.extra_headers
        }
        if options.extra_headers["Accept"] == nil {
            options.extra_headers["Accept"] = "application/octet-stream"
        }
        return try AnthropicSession.shared.SyncResponse(
            url,
            payload: nil as String?,
            requestOptions: options,
            clientOption: self.clientOption,
            method: .get
        )
    }
}

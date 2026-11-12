//
//  AnthropicFileParameters.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/11/11.
//

import Foundation
import SimpleCodableMacro

// MARK: - Upload
@BaseModelWithExtra(encodeExtra: false)
@PublicInit
public struct AnthropicFilesUploadParameters {
    public var file: FileParameters
    public var expires_in_seconds: Int?
    @transient public var workspace_id: String?
}

// MARK: - List
@BaseModelWithExtra(encodeExtra: false)
@PublicInit
public struct AnthropicFilesListParameters {
    public var ids: [String]?
    public var limit: Int?
    public var page: [String]?
    @transient public var workspace_id: String?
}

// MARK: - Retrieve
@BaseModelWithExtra(encodeExtra: false)
@PublicInit
public struct AnthropicFilesRetrieveParameters {
    @transient public var file_id: String
    @transient public var workspace_id: String?
}

// MARK: - Delete
@BaseModelWithExtra(encodeExtra: false)
@PublicInit
public struct AnthropicFilesDeletedParameters {
    @transient public var file_id: String
    @transient public var workspace_id: String?
}

// MARK: - Download
@BaseModelWithExtra(encodeExtra: false)
@PublicInit
public struct AnthropicFilesDownloadParameters {
    @transient public var file_id: String
    @transient public var workspace_id: String?
}

//
//  AsyncTypeSafeClient.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Foundation

/// Awaitable TypeSafe client, holding the `models` resource and the internal `systemOne` resource.
public class AsyncTypeSafeClient: @unchecked Sendable {
    private let clientOption: TypeSafeClientOption
    public var api_key: String { clientOption.api_key }
    public var model: String { clientOption.model }

    public var base_url: URL { clientOption.base_url }

    public var timeout: TimeInterval { clientOption.timeout }
    public var max_retries: Int { clientOption.max_retries }

    public var headers: Header { clientOption.headers }
    public var query: Query { clientOption.query }

    // MARK: Resource namespaces
    let systemOne: TypeSafeAsyncAPIResource.SystemOneAsyncResource
    public let models: TypeSafeAsyncAPIResource.ModelsAsyncResource

    public init(
        api_key: String,
        base_url: URL? = nil,
        model: String? = nil,
        timeout: TimeInterval? = nil,
        max_retries: Int? = nil,

        default_headers: Header? = nil,
        default_query: Query? = nil
    ) {
        let clientOption: TypeSafeClientOption = .init(
            api_key: api_key,
            base_url: base_url,
            model: model,
            timeout: timeout,
            max_retries: max_retries,

            default_headers: default_headers,
            default_query: default_query
        )
        self.systemOne = .init(clientOption)
        self.models    = .init(clientOption)
        self.clientOption = clientOption
    }
}

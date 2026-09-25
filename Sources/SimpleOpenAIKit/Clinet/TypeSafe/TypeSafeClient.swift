//
//  TypeSafeClient.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Foundation

public struct TypeSafeClient {
    private var clientOption: TypeSafeClientOption
    public var api_key: String { clientOption.api_key }
    public var model: String { clientOption.model }

    public var base_url: URL { clientOption.base_url }

    public var timeout: TimeInterval { clientOption.timeout }
    public var max_retries: Int { clientOption.max_retries }

    public var headers: Header { clientOption.headers }
    public var query: Query { clientOption.query }

    // MARK: Resource namespaces
    let systemOne: TypeSafeSyncAPIResource.SystemOneSyncResource
    public let models: TypeSafeSyncAPIResource.ModelsSyncResource

    public init(
        api_key: String,
        model: String = "jev-latest",
        base_url: URL = URL(string: "https://api.typesafe.ai")!,
        timeout: TimeInterval = 600,
        max_retries: Int = 2,

        default_headers: Header = [:],
        default_query: Query = [:]
    ) {
        let clientOption: TypeSafeClientOption = .init(
            api_key: api_key,
            model: model,
            base_url: base_url,
            timeout: timeout,
            max_retries: max_retries,

            default_headers: default_headers,
            default_query: default_query
        )
        self.clientOption = clientOption
        self.systemOne = .init(clientOption)
        self.models    = .init(clientOption)
    }
}

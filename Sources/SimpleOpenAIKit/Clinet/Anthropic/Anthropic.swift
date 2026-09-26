//
//  Anthropic.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public class Anthropic {
    private let clientOption: AnthropicClientOption
    public var api_key: String { clientOption.api_key }
    public var auth_token: String? { clientOption.auth_token }

    public var base_url: URL { clientOption.base_url }

    public var timeout: TimeInterval { clientOption.timeout }
    public var max_retries: Int { clientOption.max_retries }
    
    public var headers: Header { clientOption.headers }
    public var query: Query { clientOption.query }

    // MARK: Resource namespaces
    public let models: AnthropicSyncAPIResource.ModelsSyncResource
    public let completions: AnthropicSyncAPIResource.CompletionsSyncResource
    public let messages: AnthropicSyncAPIResource.MessagesSyncResource

    public init(
        api_key: String,
        auth_token: String? = nil,
        base_url: URL = URL(string: "https://api.anthropic.com")!,

        timeout: TimeInterval = 600,
        max_retries: Int = 2,

        default_headers: Header = [:],
        default_query: Query = [:]
    ) {
        let clientOption: AnthropicClientOption = .init(
            api_key: api_key,
            auth_token: auth_token,
            base_url: base_url,
            timeout: timeout,
            max_retries: max_retries,
            default_headers: default_headers,
            default_query: default_query
        )
        self.models      = .init(clientOption)
        self.completions = .init(clientOption)
        self.messages    = .init(clientOption)
        self.clientOption = clientOption
    }
}

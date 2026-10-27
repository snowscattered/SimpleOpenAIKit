//
//  AnthropicClientOption.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

/// Anthropic credentials and endpoint defaults, resolved into request headers on each call.
public struct AnthropicClientOption: APIClientOption, Sendable {
    public let api_key: String
    public let auth_token: String?

    public let base_url: URL

    public let timeout: TimeInterval
    public let max_retries: Int

    public let default_headers: Header
    public let default_query: Query

    public var headers: Header {
        var headers: [String: String] = [:]
        headers["User-Agent"] = "Simple-LLM-APIKit/Swift/1.0"
        headers = headers | self.default_headers
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"
        headers["Authorization"] = "Bearer \(api_key)"
        return headers
    }
    public var query: Query { default_query }

    public init(
        api_key: String,
        base_url: URL? = nil,
        auth_token: String? = nil,

        timeout: TimeInterval? = nil,
        max_retries: Int? = nil,

        default_headers: Header? = nil,
        default_query: Query? = nil
    ) {
        self.api_key = api_key
        self.auth_token = auth_token ?? nil
        self.base_url = base_url ?? URL(string: "https://api.anthropic.com")!
        self.timeout = timeout ?? 600
        self.max_retries = max_retries ?? 2
        self.default_headers = default_headers ?? [:]
        self.default_query = default_query ?? [:]
    }

    /// Append `path` to the Anthropic base URL.
    func getServerUrl(path: String) throws -> URL {
        let fullPath = path.hasPrefix("/") ? path : "/\(path)"
        return self.base_url.appendingPathComponent(fullPath).absoluteURL
    }
}

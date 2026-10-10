//
//  TypeSafeClientOption.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Foundation

/// TypeSafe credentials plus the default model name used when a call does not specify one.
struct TypeSafeClientOption: APIClientOption, Sendable {
    let api_key: String
    let model: String
    let base_url: URL
    let timeout: TimeInterval
    let max_retries: Int

    let default_headers: Header
    let default_query: Query

    var headers: Header {
        var headers: [String: String] = [:]
        headers["User-Agent"] = "Simple-LLM-APIKit/Swift/1.0"
        headers = headers | self.default_headers
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"
        headers["Authorization"] = "Bearer \(api_key)"
        return headers
    }
    var query: Query { default_query }

    init(
        api_key: String,
        base_url: URL? = nil,
        model: String? = nil,
        timeout: TimeInterval? = nil,
        max_retries: Int? = nil,

        default_headers: Header? = nil,
        default_query: Query? = nil
    ) {
        self.api_key = api_key
        self.model = model ?? "jev-latest"
        self.base_url = base_url ?? URL(string: "https://api.typesafe.ai")!
        self.timeout = timeout ?? 600
        self.max_retries = max_retries ?? 2
        self.default_headers = default_headers ?? [:]
        self.default_query = default_query ?? [:]
    }

    /// Append `path` to the TypeSafe base URL.
    func getServerUrl(path: String) throws -> URL {
        let fullPath = path.hasPrefix("/") ? path : "/\(path)"
        return self.base_url.appendingPathComponent(fullPath).absoluteURL
    }
}

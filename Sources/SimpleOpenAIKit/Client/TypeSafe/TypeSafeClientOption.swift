//
//  TypeSafeClientOption.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Foundation

struct TypeSafeClientOption: APIClientOption {
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
        model: String = "jev-latest",
        base_url: URL = URL(string: "https://api.typesafe.ai")!,
        timeout: TimeInterval = 600,
        max_retries: Int = 2,

        default_headers: Header = [:],
        default_query: Query = [:]
    ) {
        self.api_key = api_key
        self.model = model
        self.base_url = base_url
        self.timeout = timeout
        self.max_retries = max_retries
        self.default_headers = default_headers
        self.default_query = default_query
    }

    func getServerUrl(path: String) throws -> URL {
        let fullPath = path.hasPrefix("/") ? path : "/\(path)"
        return self.base_url.appendingPathComponent(fullPath).absoluteURL
    }
}

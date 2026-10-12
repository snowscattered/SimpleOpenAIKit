//
//  OpenAIClientOption.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/7/26.
//

import Foundation

/// OpenAI credentials and endpoint defaults: HTTP auth headers, websocket base URL, retry budget.
struct OpenAIClientOption: APIClientOption, Sendable {
    let api_key: String
    let organization: String?
    let project: String?
    let webhook_secret: String?
    
    let base_url: URL
    let websocket_base_url: URL
    
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
        if let organization = organization {
            headers["OpenAI-Organization"] = organization
        }
        if let project = project {
            headers["OpenAI-Project"] = project
        }
        headers["Authorization"] = "Bearer \(api_key)"
        return headers
    }
    var query: Query { default_query }
    
    init(
        api_key: String,
        base_url: URL? = nil,
        websocket_base_url: URL? = nil,
        
        organization: String? = nil,
        project: String? = nil,
        webhook_secret: String? = nil,

        timeout: TimeInterval? = nil,
        max_retries: Int? = nil,

        default_headers: Header? = nil,
        default_query: Query? = nil
    ) {
        self.api_key = api_key
        self.organization = organization ?? nil
        self.project = project ?? nil
        self.webhook_secret = webhook_secret ?? nil
        self.base_url = base_url ?? URL(string: "https://api.openai.com/v1")!
        self.websocket_base_url = websocket_base_url ?? URL(string: "wss://api.openai.com/v1")!
        self.timeout = timeout ?? 600
        self.max_retries = max_retries ?? 2
        self.default_headers = default_headers ?? [:]
        self.default_query = default_query ?? [:]
    }
    
    /// Append `path` to the HTTP base URL.
    func getServerUrl(path: String) throws -> URL {
        let fullPath = path.hasPrefix("/") ? path : "/\(path)"
        return self.base_url.appendingPathComponent(fullPath).absoluteURL
    }
    
    /// Append `path` to the websocket base URL.
    func getWSServerUrl(path: String) throws -> URL {
        let fullPath = path.hasPrefix("/") ? path : "/\(path)"
        return self.websocket_base_url.appendingPathComponent(fullPath).absoluteURL
    }
}

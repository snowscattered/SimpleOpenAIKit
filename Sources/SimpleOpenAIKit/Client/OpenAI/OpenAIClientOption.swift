//
//  OpenAIClientOption.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/7/26.
//

import Foundation

struct OpenAIClientOption: APIClientOption {
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
        organization: String? = nil,
        project: String? = nil,
        webhook_secret: String? = nil,
        base_url: URL = URL(string: "https://api.openai.com/v1")!,
        
        websocket_base_url: URL = URL(string: "wss://api.openai.com/v1")!,
        timeout: TimeInterval = 600,
        max_retries: Int = 2,
        
        default_headers: Header = [:],
        default_query: Query = [:]
    ) {
        self.api_key = api_key
        self.organization = organization
        self.project = project
        self.webhook_secret = webhook_secret
        self.base_url = base_url
        self.websocket_base_url = websocket_base_url
        self.timeout = timeout
        self.max_retries = max_retries
        self.default_headers = default_headers
        self.default_query = default_query
    }
    
    func getServerUrl(path: String) throws -> URL {
        let fullPath = path.hasPrefix("/") ? path : "/\(path)"
        return self.base_url.appendingPathComponent(fullPath).absoluteURL
    }
    
    func getWSServerUrl(path: String) throws -> URL {
        let fullPath = path.hasPrefix("/") ? path : "/\(path)"
        return self.websocket_base_url.appendingPathComponent(fullPath).absoluteURL
    }
}

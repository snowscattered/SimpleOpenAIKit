//
//  AnthropicClient.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public class AnthropicClient: APIClient {
    public let api_key: String
    public let auth_token: String?
    
    public let base_url: URL?
    
    public var timeout: TimeInterval
    public var max_retries: Int
    
    private let default_headers: Header
    private let default_query: Query
    
    public var headers: Header {
        get { var headers: [String: String] = [:]
            headers["User-Agent"] = "Simple-LLM-APIKit/Swift/1.0"
            headers = headers | self.default_headers
            headers["Accept"] = "application/json"
            headers["Content-Type"] = "application/json"
            headers["Authorization"] = "Bearer \(api_key)"
            return headers
        }
    }
    public var query: Query {
        get { default_query }
    }
    
    public init(
        api_key: String,
        auth_token: String? = nil,
        base_url: URL? = URL(string: "https://api.anthropic.com")!,
        
        timeout: TimeInterval = 60000,
        max_retries: Int = 2,
        
        default_headers: Header = [:],
        default_query: Query = [:]
    ) {
        self.api_key = api_key
        self.auth_token = auth_token
        self.base_url = base_url
        self.timeout = timeout
        self.max_retries = max_retries
        
        self.default_headers = default_headers
        self.default_query = default_query
    }
    
    package func getServerUrl(path: String) throws -> URL {
        let fullPath = path.hasPrefix("/") ? path : "/\(path)"
        guard let result = self.base_url?.appendingPathComponent(fullPath).absoluteURL else {
            throw AnthropicError.invalidUrl
        }
        return result
    }
}

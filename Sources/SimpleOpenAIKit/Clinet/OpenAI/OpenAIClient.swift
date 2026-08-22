//
//  OpenAIClient.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/7/26.
//

import Foundation

public class OpenAIClient: APIClient {
    public let api_key: String
//    workload_identity: WorkloadIdentity | None = None,
    public let organization: String?
    public let project: String?
    public let webhook_secret: String?
    
    public let base_url: URL?
    public let websocket_base_url: URL?
    
    public var timeout: TimeInterval
    public var max_retries: Int
    
    private let default_headers: Header
    private let default_query: Query
    
    public var headers: Header {
        get {
            var headers: [String: String] = [:]
            headers["User-Agent"] = "Simple-LLM-APIKit/Swift/1.0"
            headers = headers | self.default_headers
            headers["Accept"] = "application/json"
            headers["Content-Type"] = "application/json"
            if let organization = organization {
                headers["OpenAI-Organization"] = organization
            }
            headers["Authorization"] = "Bearer \(api_key)"
            return headers
        }
    }
    public var query: Query {
        get { default_query }
    }
    
    public init(
        api_key: String,
        organization: String? = nil,
        project: String? = nil,
        webhook_secret: String? = nil,
        base_url: URL? = URL(string: "https://api.openai.com/v1")!,
        
        websocket_base_url: URL? = URL(string: "wss://api.openai.com/v1")!,
        timeout: TimeInterval = 60000,
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
    
    package func getServerUrl(path: String) throws -> URL {
        let fullPath = path.hasPrefix("/") ? path : "/\(path)"
        guard let result = self.base_url?.appendingPathComponent(fullPath).absoluteURL else {
            throw OpenAIError.invalidUrl
        }
        return result
    }
    
    package func getWSServerUrl(path: String) throws -> URL {
        let fullPath = path.hasPrefix("/") ? path : "/\(path)"
        guard let result = self.websocket_base_url?.appendingPathComponent(fullPath).absoluteURL else {
            throw OpenAIError.invalidUrl
        }
        return result
    }
}

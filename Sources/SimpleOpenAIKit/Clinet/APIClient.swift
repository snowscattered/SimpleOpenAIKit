//
//  APIClient.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/31/26.
//

import Foundation

public protocol APIClient {
    var api_key: String { get }
    var base_url: URL? { get }
    var timeout: TimeInterval { get set }
    var max_retries: Int { get set }
    
    var headers: Header { get }
    var query: Query { get }
}

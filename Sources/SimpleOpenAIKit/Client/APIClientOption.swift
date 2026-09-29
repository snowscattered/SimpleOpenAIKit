//
//  APIClient.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/31/26.
//

import Foundation

public protocol APIClientOption: ~Copyable {
    var api_key: String { get }
    var base_url: URL { get }
    var timeout: TimeInterval { get }
    var max_retries: Int { get }
    
    var headers: Header { get }
    var query: Query { get }
}

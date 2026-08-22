//
//  RequestOptions.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/7/26.
//

import Foundation

public struct RequestOptions: Sendable {
    var extra_body: Body = [:]
    var extra_headers: Header = [:]
    var extra_query: Query = [:]
    
    var timeout: TimeInterval?
}

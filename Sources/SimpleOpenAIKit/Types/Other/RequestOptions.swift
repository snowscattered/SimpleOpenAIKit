//
//  RequestOptions.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/7/26.
//

import Foundation
import SimpleCodableMacro

@PublicInit
public struct RequestOptions: Sendable {
    public var extra_body: Body = [:]
    public var extra_headers: Header = [:]
    public var extra_query: Query = [:]
    
    public var timeout: TimeInterval?
}

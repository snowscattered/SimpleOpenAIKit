//
//  NetworkError.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/6/26.
//

import Foundation

public enum NetworkError: Error, @unchecked Sendable {
    case invalidData
    case decodeError(error: Error, message: String)
    case statusError(data: Data, request: URLRequest, response: HTTPURLResponse)
    case unknown
    case unknownError(error: Error)
    case unknownStatusError(statusCode: Int, message: String)
}

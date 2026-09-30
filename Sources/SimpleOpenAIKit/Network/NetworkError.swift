//
//  NetworkError.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/6/26.
//

import Foundation

/// Transport-level failures, thrown before a session maps them to a provider error.
public enum NetworkError: Error, @unchecked Sendable {
    /// The response body could not be used at all.
    case invalidData
    /// Decoding failed; carries the original error and the raw text that was decoded.
    case decodeError(error: any Error, message: String)
    /// A non-2xx status, with the body needed to build the provider's error type.
    case statusError(data: Data, request: URLRequest, response: HTTPURLResponse)
    /// The request failed with no usable detail.
    case unknown
    /// A transport error from below `URLSession`, kept as-is.
    case unknownError(error: any Error)
    /// A status the provider documented no body shape for.
    case unknownStatusError(statusCode: Int, message: String)
}

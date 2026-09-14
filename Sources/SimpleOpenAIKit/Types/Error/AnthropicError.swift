//
//  AnthropicError.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public struct AnthropicErrorMessage: Error, Codable, Sendable {
    public let message: String
    public let type: String?
    public let param: String?
    public let code: String?
    public let request_id: String?
}

public struct AnthropicErrorResponse: Error, Codable, Sendable {
    public let error: AnthropicErrorMessage
}

public enum AnthropicAPIError: Error {
    case badRequest(AnthropicErrorResponse?, URLRequest, HTTPURLResponse)
    case authentication(AnthropicErrorResponse?, URLRequest, HTTPURLResponse)
    case permissionDenied(AnthropicErrorResponse?, URLRequest, HTTPURLResponse)
    case notFound(AnthropicErrorResponse?, URLRequest, HTTPURLResponse)
    case conflict(AnthropicErrorResponse?, URLRequest, HTTPURLResponse)
    case unprocessableEntity(AnthropicErrorResponse?, URLRequest, HTTPURLResponse)
    case requestTooLargeError(AnthropicErrorResponse?, URLRequest, HTTPURLResponse)
    case rateLimit(AnthropicErrorResponse?, URLRequest, HTTPURLResponse)
    case serviceUnavailable(AnthropicErrorResponse?, URLRequest, HTTPURLResponse)
    case deadlineExceeded(AnthropicErrorResponse?, URLRequest, HTTPURLResponse)
    case overloaded(AnthropicErrorResponse?, URLRequest, HTTPURLResponse)
    case internalServer(statusCode: Int, payload: AnthropicErrorResponse?, URLRequest, HTTPURLResponse)
    case unexpectedStatusCode(statusCode: Int, payload: AnthropicErrorResponse?, URLRequest, HTTPURLResponse)
}

public enum AnthropicError: Error {
    case typeError(String)
    case notImplemented
    case invalidUrl
    case cannotReadFile
    case unknownError
}

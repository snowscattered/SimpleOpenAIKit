//
//  AnthropicError.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

public struct AnthropicErrorMessage: Error, Codable, Sendable {
    public let message: String
    public let type: String?
    public let param: String?
    public let code: String?
}

public struct AnthropicErrorResponse: Error, Codable, Sendable {
    public let error: AnthropicErrorMessage
}

public enum AnthropicAPIError: Error {
    case badRequest(AnthropicErrorResponse?)
    case authentication(AnthropicErrorResponse?)
    case permissionDenied(AnthropicErrorResponse?)
    case notFound(AnthropicErrorResponse?)
    case conflict(AnthropicErrorResponse?)
    case unprocessableEntity(AnthropicErrorResponse?)
    case requestTooLargeError(AnthropicErrorResponse)
    case rateLimit(AnthropicErrorResponse?)
    case internalServer(statusCode: Int, payload: AnthropicErrorResponse?)
    case unexpectedStatusCode(statusCode: Int, payload: AnthropicErrorResponse?)
}

public enum AnthropicError: Error {
    case notImplemented
    case invalidUrl
    case unknownError
}

//
//  OpenAIError.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/30/26.
//

public struct OpenAIErrorMessage: Error, Codable, Sendable {
    public let message: String
    public let type: String?
    public let param: String?
    public let code: String?
}

public struct OpenAIErrorResponse: Error, Codable, Sendable {
    public let error: OpenAIErrorMessage
}

public enum OpenAIAPIError: Error {
    case badRequest(OpenAIErrorResponse?)
    case authentication(OpenAIErrorResponse?)
    case permissionDenied(OpenAIErrorResponse?)
    case notFound(OpenAIErrorResponse?)
    case conflict(OpenAIErrorResponse?)
    case unprocessableEntity(OpenAIErrorResponse?)
    case rateLimit(OpenAIErrorResponse?)
    case internalServer(statusCode: Int, payload: OpenAIErrorResponse?)
    case unexpectedStatusCode(statusCode: Int, payload: OpenAIErrorResponse?)
}

public enum OpenAIError: Error {
    case typeError(String)
    case notImplemented
    case invalidUrl
    case cannotReadFile
    case unknownError
}

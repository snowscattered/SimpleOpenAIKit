//
//  OpenAIError.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/30/26.
//

import Foundation

public struct OpenAIErrorMessage: Error, Codable, Sendable {
    public let message: String
    public let type: String?
    public let param: String?
    public let code: String?
    public let request_id: String?
}

public struct OpenAIErrorResponse: Error, Codable, Sendable {
    public let error: OpenAIErrorMessage
}

public enum OpenAIAPIError: Error {
    case badRequest(OpenAIErrorResponse?, URLRequest, HTTPURLResponse)
    case authentication(OpenAIErrorResponse?, URLRequest, HTTPURLResponse)
    case permissionDenied(OpenAIErrorResponse?, URLRequest, HTTPURLResponse)
    case notFound(OpenAIErrorResponse?, URLRequest, HTTPURLResponse)
    case conflict(OpenAIErrorResponse?, URLRequest, HTTPURLResponse)
    case unprocessableEntity(OpenAIErrorResponse?, URLRequest, HTTPURLResponse)
    case rateLimit(OpenAIErrorResponse?, URLRequest, HTTPURLResponse)
    case internalServer(statusCode: Int, payload: OpenAIErrorResponse?, URLRequest, HTTPURLResponse)
    case unexpectedStatusCode(statusCode: Int, payload: OpenAIErrorResponse?, URLRequest, HTTPURLResponse)
}

public enum OpenAIError: Error {
    case typeError(String)
    case notImplemented
    case invalidUrl
    case cannotReadFile
    case unknownError
}

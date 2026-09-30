//
//  AnthropicSession.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

/// Shared Anthropic transport; turns HTTP failures into `AnthropicAPIError` cases.
struct AnthropicSession: Sendable, SessionProtocol {
    typealias ClientOption = AnthropicClientOption
    static let shared: AnthropicSession = AnthropicSession()
    init() { }
    
    /// Retries rate limits, 5xx (including 503, 504 and 529) and client timeouts.
    func retryErrorHandler(error: any Error) -> Bool {
        if let error = error as? AnthropicAPIError {
            switch error {
            case .rateLimit: return true
            case .internalServer: return true
            // Transient 5xx that are mapped to their own cases must keep retrying,
            // otherwise they would lose the retry they had through internalServer.
            case .serviceUnavailable, .deadlineExceeded, .overloaded: return true
            default: return false
            }
        } else if let error = error as? URLError {
            switch error.code {
            case .timedOut: return true
            default: return false
            }
        }
        return false
    }
    
    /// Map a status code and response body onto the matching `AnthropicAPIError` case.
    func AnthropicStatusError(data: Data, request: URLRequest, response: HTTPURLResponse) -> AnthropicAPIError {
        let statusCode = response.statusCode
        let payload: AnthropicErrorResponse?
        if let p = try? JSONDecoder().decode(AnthropicErrorResponse.self, from: data) {
            payload = p
        } else if let m = try? JSONDecoder().decode(AnthropicErrorMessage.self, from: data) {
            payload = .init(error: m)
        } else {
            payload = AnthropicErrorResponse(
                error: .init(
                    message: String(decoding: data, as: UTF8.self),
                    type: nil,
                    param: nil,
                    code: nil,
                    request_id: response.value(forHTTPHeaderField: "request-id")
                )
            )
        }
        switch statusCode {
        case 400: return .badRequest(payload, request, response)
        case 401: return .authentication(payload, request, response)
        case 403: return .permissionDenied(payload, request, response)
        case 404: return .notFound(payload, request, response)
        case 409: return .conflict(payload, request, response)
        case 413: return .requestTooLargeError(payload, request, response)
        case 422: return .unprocessableEntity(payload, request, response)
        case 429: return .rateLimit(payload, request, response)
        case 503: return .serviceUnavailable(payload, request, response)
        case 504: return .deadlineExceeded(payload, request, response)
        case 529: return .overloaded(payload, request, response)
        case 500...599: return .internalServer(statusCode: statusCode, payload: payload, request, response)
        default: return .unexpectedStatusCode(statusCode: statusCode, payload: payload, request, response)
        }
    }
    /// Rewrite `NetworkError.statusError` as an Anthropic error, leaving others untouched.
    func wrapError(error: any Error) -> any Error {
        if case let NetworkError.statusError(data, request, response) = error {
            return AnthropicStatusError(data: data, request: request, response: response)
        }
        return error
    }
}

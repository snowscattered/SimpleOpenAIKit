//
//  TypeSafeSession.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Foundation

/// Shared TypeSafe transport; turns HTTP failures into `TypeSafeAPIError` cases.
struct TypeSafeSession: Sendable, SessionProtocol {
    typealias ClientOption = TypeSafeClientOption
    static let shared: TypeSafeSession = TypeSafeSession()
    init() { }

    /// Retries rate limits, overload, 5xx and client timeouts.
    func retryErrorHandler(error: any Error) -> Bool {
        if let error = error as? TypeSafeAPIError {
            switch error {
            case .rateLimit, .overloaded, .internalServer: return true
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

    /// Map a status code and response body onto the matching `TypeSafeAPIError` case.
    func TypeSafeStatusError(data: Data, request: URLRequest, response: HTTPURLResponse) -> TypeSafeAPIError {
        let statusCode = response.statusCode
        let payload: TypeSafeErrorResponse
        if let decoded = try? JSONDecoder().decode(TypeSafeErrorResponse.self, from: data) {
            payload = decoded
        } else {
            payload = .init(message: String(decoding: data, as: UTF8.self))
        }
        switch statusCode {
        case 400: return .badRequest(payload, request, response)
        case 401: return .authentication(payload, request, response)
        case 403: return .permissionDenied(payload, request, response)
        case 404: return .notFound(payload, request, response)
        case 422: return .unprocessableEntity(payload, request, response)
        case 429: return .rateLimit(payload, request, response)
        case 529: return .overloaded(payload, request, response)
        case 500...599: return .internalServer(statusCode: statusCode, payload: payload, request, response)
        default: return .connection(URLError(.badServerResponse), payload: payload, request)
        }
    }
    func wrapError(error: any Error, request: URLRequest) -> TypeSafeAPIError {
        if case let NetworkError.statusError(data, request, response) = error {
            return TypeSafeStatusError(data: data, request: request, response: response)
        }
        if let apiError = error as? TypeSafeAPIError { return apiError  }
        if let urlError = error as? URLError, urlError.code == .timedOut {
            return TypeSafeAPIError.timeOut(payload: nil, request)
        }
        return TypeSafeAPIError.connection(error, payload: nil, request)
    }
}

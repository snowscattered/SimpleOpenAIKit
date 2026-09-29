//
//  TypeSafeSession.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Foundation

struct TypeSafeSession: Sendable, SessionProtocol {
    typealias ClientOption = TypeSafeClientOption
    static let shared: TypeSafeSession = TypeSafeSession()
    init() { }

    func retryErrorHandler(error: Error) -> Bool {
        if let error = error as? TypeSafeAPIError {
            switch error {
            case .rateLimit, .overloaded, .internalServer: return true
            case .unexpectedStatusCode(statusCode: let statusCode, payload: _, _, _):
                return statusCode == 408
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
        default: return .unexpectedStatusCode(statusCode: statusCode, payload: payload, request, response)
        }
    }
    func wrapError(error: Error) -> Error {
        if case let NetworkError.statusError(data, request, response) = error {
            return TypeSafeStatusError(data: data, request: request, response: response)
        }
        return error
    }
}

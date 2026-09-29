//
//  OpenAISession.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation

struct OpenAISession: Sendable, SessionProtocol {
    typealias ClientOption = OpenAIClientOption
    static let shared: OpenAISession = OpenAISession()
    init() { }
    
    func retryErrorHandler(error: Error) -> Bool {
        if let error = error as? OpenAIAPIError {
            switch error {
            case .rateLimit: return true
            case .internalServer: return true
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
    
    func OpenAIStatusError(data: Data, request: URLRequest, response: HTTPURLResponse) -> OpenAIAPIError {
        let statusCode = response.statusCode
        var payload: OpenAIErrorResponse? = nil
        if let p = try? JSONDecoder().decode(OpenAIErrorResponse.self, from: data) {
            payload = p
        } else if let m = try? JSONDecoder().decode(OpenAIErrorMessage.self, from: data) {
            payload = .init(error: m)
        }
        payload = OpenAIErrorResponse(
            error: .init(
                message: String(decoding: data, as: UTF8.self),
                type: nil,
                param: nil,
                code: nil,
                request_id: response.allHeaderFields["x-request-id"] as? String
            )
        )
        switch statusCode {
        case 400: return .badRequest(payload, request, response)
        case 401: return .authentication(payload, request, response)
        case 403: return .permissionDenied(payload, request, response)
        case 404: return .notFound(payload, request, response)
        case 409: return .conflict(payload, request, response)
        case 422: return .unprocessableEntity(payload, request, response)
        case 429: return .rateLimit(payload, request, response)
        case 500...599: return .internalServer(statusCode: statusCode, payload: payload, request, response)
        default: return .unexpectedStatusCode(statusCode: statusCode, payload: payload, request, response)
        }
    }
    func wrapError(error: Error) -> Error {
        if case let NetworkError.statusError(data, request, response) = error {
            return OpenAIStatusError(data: data, request: request, response: response)
        }
        return error
    }
}

//
//  AnthropicSession.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

package struct AnthropicSession: Sendable, SessionProtocol {
    typealias Client = AnthropicClient
    static let shared: AnthropicSession = AnthropicSession()
    init() { }
    
    func retryErrorHandler(error: Error) -> Bool {
        if let error = error as? AnthropicAPIError {
            switch error {
            case .rateLimit(_): return true
            case .internalServer(_, _): return true
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
    
    func AnthropicStatusError(statusCode: Int, data: Data) -> AnthropicAPIError {
        var payload: AnthropicErrorResponse? = nil
        if let p = try? JSONDecoder().decode(AnthropicErrorResponse.self, from: data) {
            payload = p
        } else if let m = try? JSONDecoder().decode(AnthropicErrorMessage.self, from: data) {
            payload = .init(error: m)
        } else if let s = String(data: data, encoding: .utf8) {
            payload = AnthropicErrorResponse(error: .init(message: s, type: nil, param: nil, code: nil))
        }
        switch statusCode {
        case 400:
            return .badRequest(payload)
        case 401:
            return .authentication(payload)
        case 403:
            return .permissionDenied(payload)
        case 404:
            return .notFound(payload)
        case 409:
            return .conflict(payload)
        case 422:
            return .unprocessableEntity(payload)
        case 429:
            return .rateLimit(payload)
        case 500...599:
            return .internalServer(statusCode: statusCode, payload: payload)
        default:
            return .unexpectedStatusCode(statusCode: statusCode, payload: payload)
        }
    }
    func wrapError(error: Error) -> Error {
        if case let NetworkError.statusError(statusCode, data) = error {
            return AnthropicStatusError(statusCode: statusCode, data: data)
        }
        return error
    }
}

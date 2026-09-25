//
//  TypeSafeError.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Foundation

public struct TypeSafeErrorResponse: Error, Codable, Sendable {
    public let message: String
}

public enum TypeSafeAPIError: Error {
    case badRequest(TypeSafeErrorResponse?, URLRequest, HTTPURLResponse)
    case authentication(TypeSafeErrorResponse?, URLRequest, HTTPURLResponse)
    case permissionDenied(TypeSafeErrorResponse?, URLRequest, HTTPURLResponse)
    case notFound(TypeSafeErrorResponse?, URLRequest, HTTPURLResponse)
    case unprocessableEntity(TypeSafeErrorResponse?, URLRequest, HTTPURLResponse)
    case rateLimit(TypeSafeErrorResponse?, URLRequest, HTTPURLResponse)
    case overloaded(TypeSafeErrorResponse?, URLRequest, HTTPURLResponse)
    case internalServer(statusCode: Int, payload: TypeSafeErrorResponse?, URLRequest, HTTPURLResponse)
    case unexpectedStatusCode(statusCode: Int, payload: TypeSafeErrorResponse?, URLRequest, HTTPURLResponse)
}

//
//  NoStreamUtils.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation

func syncResponse<T: Decodable & Sendable>(
    _ type: T.Type = T.self,
    request: URLRequest,
    method: HTTPMethod = .post,
    maxRetries: Int = 2,
    shouldRetry: (Error) -> Bool = { error in true }
) throws -> T {
    return try retry(maxRetries: maxRetries, shouldRetry: shouldRetry) {
        if T.self == Data.self {
            return try URLSession.shared.syncData(request) as! T
        }
        return try JSONCodable.decodeData(from: URLSession.shared.syncData(request))
    }
}

func asyncResponse<T: Decodable & Sendable>(
    _ type: T.Type = T.self,
    request: URLRequest,
    method: HTTPMethod = .post,
    maxRetries: Int = 2,
    shouldRetry: (Error) -> Bool = { error in true }
) async throws -> T {
    return try await retry(maxRetries: maxRetries, shouldRetry: shouldRetry) {
        if T.self == Data.self {
            return try await URLSession.shared.asyncData(request) as! T
        }
        return try JSONCodable.decodeData(from: await URLSession.shared.asyncData(request))
    }
}

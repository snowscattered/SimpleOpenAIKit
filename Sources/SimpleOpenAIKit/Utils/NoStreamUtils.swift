//
//  NoStreamUtils.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation

/// Send `request` and decode the whole body, retrying up to `maxRetries` times.
///
/// When `T` is `Data` the response is returned untouched, so binary payloads skip decoding.
func syncResponse<T: Decodable & Sendable>(
    _ type: T.Type = T.self,
    request: URLRequest,
    maxRetries: Int = 2,
    shouldRetry: (any Error) -> Bool = { error in true }
) throws -> T {
    return try retry(maxRetries: maxRetries, shouldRetry: shouldRetry) {
        if T.self == Data.self {
            return try URLSession.shared.syncData(request) as! T
        }
        return try decodeNetworkData(from: URLSession.shared.syncData(request))
    }
}

/// Awaitable counterpart of `syncResponse`.
func asyncResponse<T: Decodable & Sendable>(
    _ type: T.Type = T.self,
    request: URLRequest,
    maxRetries: Int = 2,
    shouldRetry: (any Error) -> Bool = { error in true }
) async throws -> T {
    return try await retry(maxRetries: maxRetries, shouldRetry: shouldRetry) {
        if T.self == Data.self {
            return try await URLSession.shared.asyncData(request) as! T
        }
        return try decodeNetworkData(from: await URLSession.shared.asyncData(request))
    }
}

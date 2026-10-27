//
//  NoStreamUtils.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation

/// Send `request` once and decode the whole body.
///
/// When `T` is `Data` the response is returned untouched, so binary payloads skip decoding.
func syncResponse<T: Decodable & Sendable>(
    _ type: T.Type = T.self,
    request: URLRequest
) throws -> T {
    if T.self == Data.self {
        return try URLSession.shared.syncData(request) as! T
    }
    return try decodeNetworkData(from: URLSession.shared.syncData(request))
}

/// Awaitable counterpart of `syncResponse`.
func asyncResponse<T: Decodable & Sendable>(
    _ type: T.Type = T.self,
    request: URLRequest
) async throws -> T {
    if T.self == Data.self {
        return try await URLSession.shared.asyncData(request) as! T
    }
    return try decodeNetworkData(from: await URLSession.shared.asyncData(request))
}

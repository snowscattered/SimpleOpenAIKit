//
//  StreamUtils.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation

private func EventConversion<T: Decodable & Sendable>(
    element: Event,
) throws -> StreamAction<T> {
    guard let rawData = element.data else { return .skip }
    // Anthropic Ping
    if rawData.range(of: #"{"type"\s*:\s*"ping"}"#, options: .regularExpression) != nil {
        return .skip
    }
    if rawData == "[DONE]" {
        return .finish
    }
    guard let jsonData = rawData.data(using: .utf8) else {
        throw NetworkError.invalidData
    }
    return .yield(try decodeData(T.self, from: jsonData))
}

func syncStreamResponse<T: Decodable & Sendable>(
    _ type: T.Type = T.self,
    request: URLRequest,
    method: HTTPMethod = .post,
    maxRetries: Int = 2,
    shouldRetry: (Error) -> Bool = { error in true }
) throws -> SyncThrowingStream<T, Error> {
    return try retry(maxRetries: maxRetries, shouldRetry: shouldRetry) {
        if T.self == Data.self {
            return try URLSession.shared.syncStreamData(request)
                .conversion { chunk throws in .yield(chunk as! T) }
        }
        return try URLSession.shared.syncSSE(request).conversion(EventConversion)
    }
}

func asyncStreamResponse<T: Decodable & Sendable>(
    _ type: T.Type = T.self,
    request: URLRequest,
    method: HTTPMethod = .post,
    maxRetries: Int = 2,
    shouldRetry: (Error) -> Bool = { error in true }
) async throws -> AsyncThrowingStream<T, Error> {
    return try await retry(maxRetries: maxRetries, shouldRetry: shouldRetry) {
        if T.self == Data.self {
            return try await URLSession.shared.asyncStreamData(request)
                .conversion { chunk throws in .yield(chunk as! T) }
        }
        return try await URLSession.shared.asyncSSE(request).conversion(EventConversion)
    }
}

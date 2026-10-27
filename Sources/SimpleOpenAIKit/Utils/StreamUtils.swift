//
//  StreamUtils.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation

/// Map one SSE field onto a stream action: empty data and Anthropic `ping` events are skipped,
/// `[DONE]` ends the stream, everything else is decoded as `T`.
private func EventConversion<T: Decodable & Sendable>(
    element: Event,
) throws -> StreamAction<T> {
    guard let jsonString = element.data else { return .skip }
    // Anthropic Ping
    if jsonString.range(of: #"{"type"\s*:\s*"ping"}"#, options: .regularExpression) != nil {
        return .skip
    }
    if jsonString.trimmingCharacters(in: .whitespacesAndNewlines) == "[DONE]" {
        return .finish
    }
    let data = Data(jsonString.utf8)
    return .yield(try decodeNetworkData(T.self, from: data))
}

/// Issue `request` once and stream the reply as decoded events.
///
/// When `T` is `Data` the SSE framing is skipped and raw chunks are yielded, which is what binary
/// downloads such as speech or video use.
func syncStreamResponse<T: Decodable & Sendable>(
    _ type: T.Type = T.self,
    request: URLRequest
) throws -> SyncThrowingStream<T, any Error> {
    if T.self == Data.self {
        return try URLSession.shared.syncStreamData(request).conversion {
            chunk throws in .yield(chunk as! T)
        }
    }
    return try URLSession.shared.syncSSE(request).conversion(EventConversion)
}

/// Awaitable counterpart of `syncStreamResponse`.
func asyncStreamResponse<T: Decodable & Sendable>(
    _ type: T.Type = T.self,
    request: URLRequest
) async throws -> AsyncThrowingStream<T, any Error> {
    if T.self == Data.self {
        return try await URLSession.shared.asyncStreamData(request).conversion {
            chunk throws in .yield(chunk as! T)
        }
    }
    return try await URLSession.shared.asyncSSE(request).conversion(EventConversion)
}

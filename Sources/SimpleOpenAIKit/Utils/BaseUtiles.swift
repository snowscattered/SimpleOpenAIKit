//
//  BaseUtiles.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/7/26.
//
import Foundation
import SimpleCodableMacro

/// Decode a response body, rethrowing failures as `NetworkError.decodeError` with the raw
/// text attached so a schema mismatch stays debuggable.
@inlinable
func decodeNetworkData<T: Decodable>(_ type: T.Type = T.self, from data: Data) throws -> T {
    do {
        return try JSONDecoder().decode(type, from: data)
    } catch {
        throw NetworkError.decodeError(error: error, message: String(decoding: data, as: UTF8.self))
    }
}

/// Blocking retry helper shared by every session call.
///
/// Backs off exponentially from `delay`, capped at 8 seconds, and gives up once `maxRetries`
/// attempts have been made or `shouldRetry` rejects the error.
@inlinable
func retry<T>(
    maxRetries: Int = 2,
    delay: TimeInterval = 0.5,
    shouldRetry: (any Error) -> Bool = { error in true },
    callback: () throws -> T
) throws -> T {
    var retries = 0
    while true {
        do {
            return try callback()
        } catch {
            retries += 1
            if retries > maxRetries || !shouldRetry(error) {
                throw error
            }
            Thread.sleep(forTimeInterval: min(delay * pow(2.0, Double(retries - 1)), 8.0))
        }
    }
}

/// Awaitable counterpart of `retry`; sleeps cooperatively, so cancelling the task stops the loop.
@inlinable
func retry<T>(
    maxRetries: Int = 2,
    delay: TimeInterval = 1.0,
    shouldRetry: (any Error) -> Bool = { error in true },
    callback: () async throws -> T
) async throws -> T {
    var retries = 0
    while true {
        do {
            return try await callback()
        } catch {
            retries += 1
            if retries > maxRetries || !shouldRetry(error) {
                throw error
            }
            try await Task.sleep(seconds: min(delay * pow(2.0, Double(retries - 1)), 8.0))
        }
    }
}

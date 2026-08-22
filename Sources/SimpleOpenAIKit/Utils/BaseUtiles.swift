//
//  BaseUtiles.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/7/26.
//
import Foundation
import SimpleCodableMacro

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case update = "UPDATE"
    case delete = "DELETE"
}

struct JSONCodable {
    static let decoder: JSONDecoder = {
        let d = JSONDecoder()
        return d
    }()
    static let encoder: JSONEncoder = {
        let e = JSONEncoder()
        return e
    }()
    @inlinable
    static func decodeData<T: Decodable>(_ type: T.Type = T.self, from data: Data) throws -> T {
        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw NetworkError.decodeError(error: error, message: String(decoding: data, as: UTF8.self))
        }
    }
}

@inlinable
func retry<T>(
    maxRetries: Int = 2,
    delay: TimeInterval = 0.5,
    shouldRetry: (Error) -> Bool = { error in true },
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

@inlinable
func retry<T>(
    maxRetries: Int = 2,
    delay: TimeInterval = 1.0,
    shouldRetry: (Error) -> Bool = { error in true },
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

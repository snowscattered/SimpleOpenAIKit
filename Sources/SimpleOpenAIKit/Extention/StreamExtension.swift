//
//  StreamExtension.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/3/26.
//

import Foundation

public enum StreamAction<Element: Sendable>: Sendable {
    case yield(Element)
    case yieldMore([Element])
    case skip
    case finish
}
// MARK: - AsyncStream
public extension AsyncSequence {
    func conversion<T>(
        _ transform: @escaping @Sendable (Element) async -> StreamAction<T>
    ) -> AsyncStream<T> where Self: Sendable, T: Sendable {
        AsyncStream<T> { continuation in
            let task = Task.detached {
                do {
                    for try await value in self {
                        if Task.isCancelled { break }
                        switch await transform(value) {
                        case .yield(let transformed): continuation.yield(transformed)
                        case .yieldMore(let transformeds):
                            for transformed in transformeds {
                                continuation.yield(transformed)
                            }
                        case .skip: continue
                        case .finish: break
                        }
                    }
                } catch { }
                continuation.finish()
            }
            continuation.onTermination = { _ in task.cancel() }
        }
    }
    func conversion<T>(
        _ transform: @escaping @Sendable (Element) async throws -> StreamAction<T>
    ) -> AsyncThrowingStream<T, Error> where Self: Sendable, T: Sendable {
        AsyncThrowingStream<T, Error> { continuation in
            let task = Task.detached {
                do {
                    for try await value in self {
                        if Task.isCancelled { break }
                        switch try await transform(value) {
                        case .yield(let transformed): continuation.yield(transformed)
                        case .yieldMore(let transformeds):
                            for transformed in transformeds {
                                continuation.yield(transformed)
                            }
                        case .skip: continue
                        case .finish: break
                        }
                    }
                    continuation.finish()
                } catch { continuation.finish(throwing: error) }                
            }
            continuation.onTermination = { _ in task.cancel() }
        }
    }
    func forEach(_ body: (Element) throws -> Void?) async throws {
        var iterator = self.makeAsyncIterator()
        while let element = try await iterator.next() {
            if try body(element) == nil { break }
        }
    }
}
// MARK: - SyncStream
public extension SyncSequence {
    func conversion<T>(
        _ transform: @escaping @Sendable (Element) -> StreamAction<T>
    ) -> SyncStream<T> where Self: Sendable, T: Sendable {
        SyncStream<T> { continuation in
            let task = Task.detached(priority: Task.currentPriority) {
                var iterator = self.makeIterator()
                do {
                    while let value = try iterator.next() {
                        if Task.isCancelled { break }
                        switch transform(value) {
                            case .yield(let transformed): continuation.yield(transformed)
                            case .yieldMore(let transformeds):
                                for transformed in transformeds {
                                    continuation.yield(transformed)
                                }
                            case .skip: continue
                            case .finish: break
                        }
                    }
                    continuation.finish()
                } catch { }
            }
            continuation.onTermination = { _ in
                task.cancel()
                self.signal()
            }
        }
    }
    func conversion<T>(
        _ transform: @escaping @Sendable (Element) throws -> StreamAction<T>
    ) -> SyncThrowingStream<T, Error> where Self: Sendable, T: Sendable {
        SyncThrowingStream<T, any Error> { continuation in
            let task = Task.detached(priority: Task.currentPriority) {
                var iterator = self.makeIterator()
                do {
                    while let value = try iterator.next() {
                        if Task.isCancelled { break }
                        switch try transform(value) {
                            case .yield(let transformed): continuation.yield(transformed)
                            case .yieldMore(let transformeds):
                                for transformed in transformeds {
                                    continuation.yield(transformed)
                                }
                            case .skip: continue
                            case .finish: break
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
            continuation.onTermination = { _ in
                task.cancel()
                self.signal()
            }
        }
    }
    func forEach(_ body: @escaping (Element) throws -> Void?) throws {
        var iterator = self.makeIterator()
        while let element = try iterator.next() {
            if try body(element) == nil { break }
        }
    }
}

// MARK: - Write File
extension AsyncSequence where Element == Data {
    public func write(to url: URL) async throws {
        guard url.isFileURL else { throw IOStreamError.invalidURL }
        guard let outputStream = OutputStream(url: url, append: false) else { throw IOStreamError.creationFailed }
        try await outputStream.with {
            try await outputStream.writeFile(stream: self)
        }
    }
}
extension SyncSequence where Element == Data {
    public func write(to url: URL) throws {
        guard url.isFileURL else { throw IOStreamError.invalidURL }
        guard let outputStream = OutputStream(url: url, append: false) else { throw IOStreamError.creationFailed }
        try outputStream.with {
            try outputStream.writeFile(stream: self)
        }
    }
}

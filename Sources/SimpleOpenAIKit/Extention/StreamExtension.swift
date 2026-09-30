//
//  StreamExtension.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/3/26.
//

import Foundation

/// What one `conversion` transform decided to do with an upstream element.
///
/// This is the vocabulary of the streaming pipeline: `.skip` drops keep-alive frames, `.yieldMore`
/// fans a single chunk out into several events, and `.finish` stops early at `[DONE]`.
public enum StreamAction<Element: Sendable>: Sendable {
    /// Emit one transformed element.
    case yield(Element)
    /// Emit every element of `values`, in order.
    case yieldMore([Element])
    /// Drop this element and keep iterating.
    case skip
    /// End the stream here.
    case finish
}
// MARK: - AsyncStream
public extension AsyncSequence {
    /// Rebuild the stream by mapping each element through `transform`.
    ///
    /// - Returns: A stream of transformed elements; cancelling it stops the upstream iteration.
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
    /// Throwing variant: a failure from `transform` ends the stream with that error.
    func conversion<T>(
        _ transform: @escaping @Sendable (Element) async throws -> StreamAction<T>
    ) -> AsyncThrowingStream<T, any Error> where Self: Sendable, T: Sendable {
        AsyncThrowingStream<T, any Error> { continuation in
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
    /// Await every element, stopping early if `body` returns `nil`.
    func forEach(_ body: (Element) throws -> Void?) async throws {
        var iterator = self.makeAsyncIterator()
        while let element = try await iterator.next() {
            if try body(element) == nil { break }
        }
    }
}
// MARK: - SyncStream
public extension SyncSequence {
    /// Blocking counterpart of `conversion(_:)`: a detached task feeds a `SyncStream`.
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
    /// Throwing variant that surfaces a `transform` failure to the blocking consumer.
    func conversion<T>(
        _ transform: @escaping @Sendable (Element) throws -> StreamAction<T>
    ) -> SyncThrowingStream<T, any Error> where Self: Sendable, T: Sendable {
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
    /// Consume every element, stopping early if `body` returns `nil`.
    func forEach(_ body: @escaping (Element) throws -> Void?) throws {
        var iterator = self.makeIterator()
        while let element = try iterator.next() {
            if try body(element) == nil { break }
        }
    }
}

// MARK: - Write File
extension AsyncSequence where Element == Data {
    /// Write the stream to a local file, one chunk at a time.
    public func write(to url: URL) async throws {
        guard url.isFileURL else { throw IOStreamError.invalidURL }
        guard let outputStream = OutputStream(url: url, append: false) else { throw IOStreamError.creationFailed }
        try await outputStream.with {
            try await outputStream.writeFile(stream: self)
        }
    }
}
extension SyncSequence where Element == Data {
    /// Blocking counterpart of `write(to:)`.
    public func write(to url: URL) throws {
        guard url.isFileURL else { throw IOStreamError.invalidURL }
        guard let outputStream = OutputStream(url: url, append: false) else { throw IOStreamError.creationFailed }
        try outputStream.with {
            try outputStream.writeFile(stream: self)
        }
    }
}

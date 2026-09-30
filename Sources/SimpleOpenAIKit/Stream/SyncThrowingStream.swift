//
//  SyncThrowingStream.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/3/26.
//

import Foundation

/// `SyncStream` that can also fail: a thrown error is delivered to the consumer's next call.
///
/// Elements already buffered are drained before the error surfaces, and the error is cleared after it
/// is thrown so a second iteration does not see it again.
public struct SyncThrowingStream<Element: Sendable, Failure: Error>: Sendable {
    /// The producer-side handle: enqueue elements, then finish normally or with an error.
    public final class Continuation: @unchecked Sendable {
        private var buffer: [Element] = []
        private var isFinished = false
        private var isCancelled = false
        private var error: Failure?
        fileprivate let condition = NSCondition()
        
        /// Why iteration stopped, carrying the failure when the producer finished with one.
        public enum Termination: Sendable {
            case finished(Failure?)
            case cancelled
        }
        /// Called once when the stream finishes or its consumer goes away.
        public var onTermination: (@Sendable (Termination) -> Void)?

        /// Take the next buffered element, blocking until one arrives, the stream ends, or it failed.
        internal func consume() throws -> Element? {
            condition.lock()
            defer { condition.unlock() }
            
            while buffer.isEmpty && !isFinished && !isCancelled && !Task.isCancelled{
                condition.wait()
            }
            guard !buffer.isEmpty else {
                if let error = self.error {
                    self.error = nil
                    throw error
                }
                return nil
            }
            return buffer.removeFirst()
        }
        
        /// Add `value` to the queue; ignored once the stream has ended or been cancelled.
        public func yield(_ value: Element) {
            condition.lock()
            defer { condition.unlock() }
            guard !isFinished && !isCancelled else { return }
            buffer.append(value)
            condition.signal()
        }
        
        /// End the stream after the buffered elements have been consumed.
        public func finish() {
            finish(throwing: nil)
        }
        
        /// End the stream, surfacing `error` once the buffered elements are drained.
        public func finish(throwing error: Failure?) {
            condition.lock()
            defer { condition.unlock() }
            guard !isFinished else { return }
            isFinished = true
            self.error = error
            condition.signal()
            executeTermination(.finished(error))
        }
        
        /// Producer-side notice that the consumer released its iterator.
        internal func consumerDidTerminate() {
            condition.lock()
            defer { condition.unlock() }
            guard !isFinished && !isCancelled else { return }
            isCancelled = true
            condition.signal()
            executeTermination(.cancelled)
        }
        
        private func executeTermination(_ reason: Termination) {
            let handler = onTermination
            onTermination = nil
            handler?(reason)
        }
    }
    
    private var continuation: Continuation
    /// Start `build` on a detached task and return the stream it feeds.
    public init(_ build: @escaping @Sendable (Continuation) -> Void) {
        self.continuation = Continuation()
        Task.detached(priority: Task.currentPriority) { [self] in build(self.continuation) }
    }
    /// Wake the condition so a blocked consumer re-checks its exit conditions.
    public func signal() {
        self.continuation.condition.signal()
    }
}

extension SyncThrowingStream: SyncSequence {
    /// Blocking iterator that rethrows the producer's failure from `next()`.
    public final class Iterator: SyncIteratorProtocol {
        let continuation: Continuation
        
        init(continuation: Continuation) {
            self.continuation = continuation
        }
        public func next() throws -> Element? {
            try self.continuation.consume()
        }
        deinit {
            self.continuation.consumerDidTerminate()
        }
    }
    
    public func makeIterator() -> Iterator {
        Iterator(continuation: continuation)
    }
}

extension SyncThrowingStream {
    /// Split the stream and its continuation, for producers that hold the handle directly.
    public static func makeStream(
        of elementType: Element.Type = Element.self,
        throwing failureType: Failure.Type = Failure.self
    ) -> (stream: SyncThrowingStream<Element, Failure>, continuation: Continuation) {
        let cont = Continuation()
        let stream = SyncThrowingStream(continuation: cont)
        return (stream, cont)
    }
    private init(continuation: Continuation) {
        self.continuation = continuation
    }
}
// SyncPrefixSequence
extension SyncThrowingStream {
    /// A stream that stops after `count` elements, forwarding upstream failures unchanged.
    public func prefix(_ count: Int) -> SyncThrowingStream<Element, Failure> {
        return SyncThrowingStream<Element, Failure> { continuation in
            let task = Task.detached(priority: Task.currentPriority) {
                var i = 0
                let iterator = self.makeIterator()
                do {
                    while i < count, let value = try iterator.next() {
                        if Task.isCancelled { break }
                        continuation.yield(value)
                        i += 1
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: (error as! Failure))
                }
            }
            continuation.onTermination = { _ in
                task.cancel()
                self.signal()
            }
        }
    }
}

//
//  SyncStream.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/3/26.
//

import Foundation

/// The synchronous counterpart of `AsyncStream`: a buffered queue produced on a background task and
/// drained by a blocking `for ... in` loop.
///
/// `Continuation` is thread-safe and unbounded, so a producer never waits for a slow consumer. The
/// consumer parks on a condition until an element arrives, the producer finishes, or the task is
/// cancelled; dropping the iterator cancels the producer through `onTermination`.
public struct SyncStream<Element: Sendable>: Sendable {
    /// The producer-side handle: enqueue elements and end the stream.
    public final class Continuation: @unchecked Sendable {
        private var buffer: [Element] = []
        private var isFinished = false
        private var isCancelled = false
        fileprivate let condition = NSCondition()

        /// Why iteration stopped.
        public enum Termination: Sendable {
            case finished
            case cancelled
        }
        
        /// Called once when the stream finishes or its consumer goes away.
        public var onTermination: (@Sendable (Termination) -> Void)?

        /// Take the next buffered element, blocking until one arrives or the stream ends.
        func consume() -> Element? {
            condition.lock()
            defer { condition.unlock() }
            while buffer.isEmpty && !isFinished && !isCancelled && !Task.isCancelled {
                condition.wait()
            }
            guard !buffer.isEmpty else { return nil}
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
            condition.lock()
            defer { condition.unlock() }
            guard !isFinished else { return }
            isFinished = true
            condition.signal()
            executeTermination(.finished)
        }
        
        /// Producer-side notice that the consumer released its iterator.
        func consumerDidTerminate() {
            condition.lock()
            defer { condition.unlock() }
            guard !isFinished && !isCancelled else { return }
            isCancelled = true
            condition.signal()
            executeTermination(.cancelled)
        }
        
        /// Run and clear the termination handler exactly once.
        private func executeTermination(_ reason: Termination) {
            let handler = onTermination
            onTermination = nil
            handler?(reason)
            self.condition.signal()
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

extension SyncStream: SyncSequence, Sequence {
    /// Blocking iterator over the stream's buffer.
    public final class Iterator: SyncIteratorProtocol, IteratorProtocol {
        let continuation: SyncStream.Continuation
        init(continuation: SyncStream.Continuation) {
            self.continuation = continuation
        }
        public func next() -> Element? {
            self.continuation.consume()
        }
        deinit {
            self.continuation.consumerDidTerminate()
        }
    }
    
    /// Start a second, independent iteration of the same stream.
    public func makeIterator() -> Self.Iterator {
        Iterator(continuation: continuation)
    }
}
extension SyncStream {
    /// Split the stream and its continuation, for producers that hold the handle directly.
    public static func makeStream(
        of elementType: Element.Type = Element.self
    ) -> (stream: SyncStream<Element>, continuation: Continuation) {
        let cont = Continuation()
        let stream = SyncStream(continuation: cont)
        return (stream, cont)
    }
    private init(continuation: Continuation) {
        self.continuation = continuation
    }
}
// SyncPrefixSequence
extension SyncStream where Element: Sendable {
    /// A stream that stops after `count` elements, cancelling the upstream producer when it does.
    public func prefix(_ count: Int) -> SyncStream<Element> {
        return SyncStream { continuation in
            let task = Task.detached(priority: Task.currentPriority) {
                var i = 0
                let iterator = self.makeIterator()
                while i < count, let value = iterator.next() {
                    if Task.isCancelled { break }
                    continuation.yield(value)
                    i += 1
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
                self.signal()
            }
        }
    }
}

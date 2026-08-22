//
//  SyncStream.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/3/26.
//

import Foundation

public struct SyncStream<Element: Sendable>: Sendable {
    public final class Continuation: @unchecked Sendable {
        private var buffer: [Element] = []
        private var isFinished = false
        private var isCancelled = false
        fileprivate let condition = NSCondition()

        public enum Termination: Sendable {
            case finished
            case cancelled
        }
        
        public var onTermination: (@Sendable (Termination) -> Void)?
        
        func consume() -> Element? {
            condition.lock()
            defer { condition.unlock() }
            while buffer.isEmpty && !isFinished && !isCancelled && !Task.isCancelled {
                condition.wait()
            }
            guard !buffer.isEmpty else { return nil}
            return buffer.removeFirst()
        }
        
        public func yield(_ value: Element) {
            condition.lock()
            defer { condition.unlock() }
            guard !isFinished && !isCancelled else { return }
            buffer.append(value)
            condition.signal()
        }
        
        public func finish() {
            condition.lock()
            defer { condition.unlock() }
            guard !isFinished else { return }
            isFinished = true
            condition.signal()
            executeTermination(.finished)
        }
        
        func consumerDidTerminate() {
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
            self.condition.signal()
        }
    }
    
    private var continuation: Continuation
    public init(_ build: @escaping @Sendable (Continuation) -> Void) {
        self.continuation = Continuation()
        Task.detached(priority: Task.currentPriority) { [self] in build(self.continuation) }
    }
    public func signal() {
        self.continuation.condition.signal()
    }
}

extension SyncStream: SyncSequence, Sequence {
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
    
    public func makeIterator() -> Self.Iterator {
        Iterator(continuation: continuation)
    }
}
extension SyncStream {
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

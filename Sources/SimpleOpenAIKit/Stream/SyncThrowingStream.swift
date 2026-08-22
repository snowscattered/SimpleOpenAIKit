//
//  SyncThrowingStream.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/3/26.
//

import Foundation

public struct SyncThrowingStream<Element: Sendable, Failure: Error>: Sendable {
    public final class Continuation: @unchecked Sendable {
        private var buffer: [Element] = []
        private var isFinished = false
        private var isCancelled = false
        private var error: Failure?
        fileprivate let condition = NSCondition()
        
        public enum Termination: Sendable {
            case finished(Failure?)
            case cancelled
        }
        public var onTermination: (@Sendable (Termination) -> Void)?
        
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
        
        public func yield(_ value: Element) {
            condition.lock()
            defer { condition.unlock() }
            guard !isFinished && !isCancelled else { return }
            buffer.append(value)
            condition.signal()
        }
        
        public func finish() {
            finish(throwing: nil)
        }
        
        public func finish(throwing error: Failure?) {
            condition.lock()
            defer { condition.unlock() }
            guard !isFinished else { return }
            isFinished = true
            self.error = error
            condition.signal()
            executeTermination(.finished(error))
        }
        
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
    public init(_ build: @escaping @Sendable (Continuation) -> Void) {
        self.continuation = Continuation()
        Task.detached(priority: Task.currentPriority) { [self] in build(self.continuation) }
    }
    public func signal() {
        self.continuation.condition.signal()
    }
}

extension SyncThrowingStream: SyncSequence {
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

//
//  AsyncStreamTests.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/4/26.
//

import Testing
import Foundation
import SimpleCodableMacro
@testable import SimpleOpenAIKit

func AsyncStreamGenerator() -> AsyncStream<Int> {
    AsyncStream { continuation in
        let task = Task {
            for i in 0...10 {
                if Task.isCancelled { break }
                print(i)
                continuation.yield(i)
                try await Task.sleep(for: .seconds(1))
            }
            continuation.finish()
        }
        continuation.onTermination = { _ in
            print("Generation End")
            task.cancel()
        }
    }
}
func AsyncStreamAdd(stream: AsyncStream<Int>) -> AsyncStream<Int> {
    AsyncStream { continuation in
        let task = Task.detached {
            for await value in stream {
                if Task.isCancelled { break }
                continuation.yield(value + 100)
            }
            continuation.finish()
        }
        continuation.onTermination = { _ in
            task.cancel()
        }
    }
}
enum StreamError: Error {
    case test
}
func AsyncThrowingStreamGenerator() -> AsyncThrowingStream<Int, Error> {
    AsyncThrowingStream { continuation in
        let task = Task {
            for i in 0...10 {
                if Task.isCancelled { break }
                print(i)
                continuation.yield(i)
                try await Task.sleep(for: .seconds(1))
                if i == 5 {
                    continuation.finish(throwing: StreamError.test)
                }
            }
            continuation.finish()
        }
        continuation.onTermination = { _ in
            print("Generation End")
            task.cancel()
        }
    }
}

@Suite("AsyncStreamTests")
struct AsyncStreamTests {
    @Test func AsyncStreamTest() async throws {
        for try await value in AsyncStreamGenerator().conversion({ element in
            .yield(element + 100)
        }).conversion({ element in
            .yield(element * 2)
        }).prefix(3) {
            print(value)
        }
//        for await i in AsyncStreamGenerator().flatMap({ value in
//            if value == 2 {
//                return AsyncStream<Int> { continuation in
//                    Task {
//                        continuation.yield(2 + 100)
//                        try await Task.sleep(seconds: 0.6)
//                        continuation.yield(2 + 100)
//                        continuation.finish()
//                    }
//                }
//            }
//            return AsyncStream<Int> { continuation in
//                continuation.yield(value + 100)
//                continuation.finish()
//            }
//        }) {
//            print(i)
//        }
//        for await value in AsyncStreamGenerator().map({ element in
//            element + 100
//        }).map({ element in
//            element * 2
//        }).prefix(3) {
//            print(value)
//        }
        print("Break")
        try await Task.sleep(for: .seconds(5))
    }
    
    @Test func AsyncThrowingStreamTest() async throws {
        let s = AsyncThrowingStreamGenerator()
        for try await value in s.conversion({ element in
            .yield(element + 100)
        }).prefix(3) {
            print(value)
        }
//        for try await value in s.compactMap({ element -> Int? in
//            if element == 0 {
//                return nil
//            }
//            return element + 100
//        }).prefix(3) {
//            print(value)
//        }
        _ = consume s
        print("Break")
        try await Task.sleep(for: .seconds(5))
    }
}

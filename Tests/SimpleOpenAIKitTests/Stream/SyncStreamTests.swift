//
//  SyncStreamTests.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/4/26.
//
import Testing
import Foundation
import SimpleCodableMacro
@testable import SimpleOpenAIKit

func SyncStreamGenerator() -> SyncStream<Int> {
    SyncStream { continuation in
        let task = Task.detached(priority: Task.currentPriority) {
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
func SyncThrowingStreamGenerator() -> SyncThrowingStream<Int, Error> {
    SyncThrowingStream { continuation in
        let task = Task.detached(priority: Task.currentPriority) {
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


@Suite("SyncStreamTests")
struct SyncStreamTests {
    @Test func SyncStreamTest() async throws {
        SyncStreamGenerator().conversion({ element in
            .yield(element + 100)
        }).conversion({ element in
            .yield(element * 2)
        }).prefix(3).forEach { value in
            print(value)
        }
        
//        let s = SyncStreamGenerator().conversion({ element in
//            .yield(element + 100)
//        }).conversion({ element in
//            .yield(element * 2)
//        }).prefix(3)
//        for value in s {
//            print(value)
//        }
//        _ = consume s
        
//        for value in SyncStreamGenerator().lazy.map({ element in
//            element + 100
//        }).map({ element in
//            element * 2
//        }).prefix(3) {
//            print(value)
//        }
        print("Break")
        try await Task.sleep(for: .seconds(5))
        
    }
    @Test func SyncThrowingStreamTest() async throws {
        let s = SyncThrowingStreamGenerator()
        try s.prefix(3).forEach { value in
            print(value + 100)
        }
        _ = consume s
        print("Break")
        try await Task.sleep(for: .seconds(5))
    }
    
    func SyncStreamResultGenerator() -> SyncStream<Result<Int, Error>> {
        SyncStream { continuation in
            let task = Task.detached(priority: Task.currentPriority) {
                for i in 0...10 {
                    if Task.isCancelled { break }
                    if i == 5 {
                        continuation.yield(.failure(StreamError.test))
                        break
                    }
                    print(i)
                    continuation.yield(.success(i))
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
    @Test func SyncStreamResultTest() async throws {
        for value in SyncStreamResultGenerator().lazy.compactMap({ element in
            switch element {
            case .success(let value): return value + 100
            case .failure(_): return nil
            }
        }) {
            print(value)
        }
        print("Break")
        try await Task.sleep(for: .seconds(5))
        
    }
}

//
//  CompletionsAsyncTest.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/13/26.
//

import Testing
import Foundation
@testable import SimpleOpenAIKit

@Suite("CompletionsAsyncTest")
struct CompletionsAsyncTest {
    let param: CompletionParameters = .init(
        model: "deepseek-v4-pro",
        prompt: "def fib(a):",
        suffix: "    return fib(a-1) + fib(a-2)",
        max_tokens: 128,
    )
    @Test func asyncCompletionData() async throws {
        let res = try await asyncClient.completions.create(
            parameters: param,
        )
        print(res)
        print()
        print(res.choices.first?.text ?? "No Content")
    }
    @Test func asyncCompletionStream() async throws {
        let res = try await asyncClient.completions.stream(
            parameters: param
        )
        for try await chunk in res {
            print(chunk)
        }
    }
}

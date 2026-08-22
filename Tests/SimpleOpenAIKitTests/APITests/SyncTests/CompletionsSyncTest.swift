//
//  CompletionsSyncTest.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/13/26.
//

import Testing
import Foundation
@testable import SimpleOpenAIKit

@Suite("CompletionsSyncTest")
struct CompletionsSyncTest {
    let param: CompletionParameters = .init(
        model: "deepseek-v4-pro",
        prompt: "def fib(a):",
        suffix: "    return fib(a-1) + fib(a-2)",
        max_tokens: 128,
    )
    @Test func syncCompletionData() throws {
        let res = try client.completions.create(
            parameters: param,
        )
        print(res)
        print()
        print(res.choices.first?.text ?? "No Content")
    }
    @Test func syncCompletionStream() throws {
        let res = try client.completions.stream(
            parameters: param
        )
        try res.forEach { chunk in
            print(chunk)
        }
    }
}

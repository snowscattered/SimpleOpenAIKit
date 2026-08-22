//
//  MessageAsyncTests.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/6/26.
//
import
Testing
import Foundation
@testable import SimpleOpenAIKit

@Suite("MessageAsyncTests")
struct MessageAsyncTests {
    let param: MessageParameters = .init(
        model: "deepseek-v4-pro",
        messages: [
            .init(role: .user, content: "who are you？")
        ],
        tools: [.web_search],
        max_tokens: 1024,
    )
    @Test func asyncCompletionData() async throws {
        let res = try await anthropicAsyncClient.messages.create(
            parameters: param,
        )
        print(res)
        print()
        print(res.content)
    }
    @Test func asyncCompletionStream() async throws {
        let res = try await anthropicAsyncClient.messages.stream(
            parameters: param
        )
        for try await chunk in res {
            print()
            print(chunk)
        }
    }
}

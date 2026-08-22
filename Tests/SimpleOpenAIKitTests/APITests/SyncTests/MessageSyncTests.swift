//
//  MessageSyncTests.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/6/26.
//

import Testing
import Foundation
@testable import SimpleOpenAIKit

@Suite("MessageSyncTests")
struct MessageSyncTests {
    let param: MessageParameters = .init(
        model: "deepseek-v4-pro",
        messages: [
//            .init(role: .user, content: "who are you?")
            .user("who are you?")
        ],
//        tools: [.web_search],
        max_tokens: 1024,
    )
    @Test func syncCompletionData() throws {
        let res = try anthropicClient.messages.create(
            parameters: param,
        )
        print(res)
    }
    @Test func syncCompletionStream() throws {
        let res = try anthropicClient.messages.stream(
            parameters: param
        )
        try res.forEach { chunk in
            print(chunk)
        }
    }
}

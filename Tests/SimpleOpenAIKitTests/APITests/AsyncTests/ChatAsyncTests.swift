//
//  ChatAsyncTests.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Testing
import Foundation
@testable import SimpleOpenAIKit

@Suite("ChatAsyncTests")
struct ChatAsyncTests {
    let param: ChatParameters = .init(
        model: "deepseek-v4-pro",
        messages: [
            .user("who are you？"),
        ]
    )
    @Test func asyncChatData() async throws {
        let res = try await asyncClient.chat.completions.create(
            parameters: param,
            requestOptions: .init(
                extra_body: ["thinking": ["type": "disabled"]]
            )
        )
        print(res.choices.first?.message.reasoning_content ?? "No Reasoning Content")
        print()
        print(res.choices.first?.message.content ?? "No Content")
    }
    @Test func asyncChatStream() async throws {
        let res = try await asyncClient.chat.completions.stream(
            parameters: param
        )
        for try await chunk in res {
//            print(chunk)
            if let content = chunk.choices.first?.delta.content {
                print(content, terminator: "")
            } else if let reason = chunk.choices.first?.delta.reasoning_content {
                print(reason)
            }
        }
    }
}

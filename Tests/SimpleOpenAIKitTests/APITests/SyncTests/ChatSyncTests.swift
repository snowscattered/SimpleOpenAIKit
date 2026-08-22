//
//  ChatTests.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Testing
import Foundation
@testable import SimpleOpenAIKit

@Suite("ChatSyncTests")
struct ChatSyncTests {
    let param: ChatParameters = .init(
        model: "deepseek-v4-pro",
        messages: [
            .user("who are you?"),
        ]
    )
    @Test func syncChatData() throws {
        let res = try client.chat.completions.create(
            parameters: param,
            requestOptions: .init(
                extra_body: ["thinking": ["type": "disabled"]]
            )
        )
        print(res.choices.first?.message.reasoning_content ?? "No Reasoning Content")
        print()
        print(res.choices.first?.message.content ?? "No Content")
    }
    @Test func syncChatStream() throws {
        let res = try client.chat.completions.stream(
            parameters: param
        )
        try res.forEach { chunk in
            print(chunk)
        }
    }
}

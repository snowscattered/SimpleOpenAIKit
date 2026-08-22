//
//  SyncSessionTests.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/22/26.
//

import Testing
import Foundation
import SimpleCodableMacro
@testable import SimpleOpenAIKit

@Suite("SyncSessionTests")
struct SyncSessionTests {
    let url = URL(string: "https://api.deepseek.com/v1/chat/completions")!
    var payload: ChatParameters = .init(
        model: "deepseek-v4-pro",
        messages: [
            .user("你是谁？")
        ],
    )
    let client = OpenAI(
        api_key: "NoKey",
        base_url: URL(string: "https://api.deepseek.com")!,
        max_retries: 0
    )
    @Test mutating func syncData() throws {
        payload.stream = false
        let response: BaseType = try OpenAISession.shared.SyncResponse(
            url,
            payload: payload,
            requestOptions: nil,
            client: client,
            method: .post
        )
        print(response)
    }
    @Test mutating func syncStream() throws {
        payload.stream = true
        let Streram: SyncThrowingStream<BaseType, Error> = try OpenAISession.shared.SyncStreamResponse(
            url,
            payload: payload,
            requestOptions: .init(
                extra_body: ["thinking": ["type": "disabled"]]
            ),
            client: client,
            method: .post
        )
        try Streram.forEach { value in
            print(value)
        }
    }
}

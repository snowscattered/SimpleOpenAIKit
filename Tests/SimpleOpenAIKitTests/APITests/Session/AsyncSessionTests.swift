//
//  AsyncSessionTests.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/22/26.
//

import Testing
import Foundation
import SimpleCodableMacro
@testable import SimpleOpenAIKit

struct OBJ: Codable & Sendable {
    public var a: Int
}

@Suite("AsyncSessionTests")
struct AsyncSessionTests {
    let url = URL(string: "https://api.deepseek.com/chat/completions")!
    var payload: ChatParameters = .init(
        model: "deepseek-v4-pro",
        messages: [
            .user("你是谁？"),
        ],
        extra: ["thinking": ["type": "disabled"]]
    )
    let client = AsyncOpenAI(
        api_key: "NoKey",
        base_url: URL(string: "https://api.deepseek.com")!,
        max_retries: 0
    )
    @Test mutating func makeRequest() async throws {
        payload.stream = false
        let request = try OpenAISession.shared.getRequest(
            url,
            payload: payload,
            requestOptions: RequestOptions(
                extra_body: .init(OBJ(a: 10))
            ),
            client: client,
            method: .post
        )
        guard let string = String(data: request.httpBody!, encoding: .utf8) else {
            throw EncodingError.invalidValue(
                self,
                EncodingError.Context(
                    codingPath: [],
                    debugDescription: "Failed to convert the encoded data to a UTF‑8 string."
                )
            )
        }
        print(string)
        
    }
    @Test mutating func asyncData() async throws {
        payload.stream = false
        let response: BaseType = try await OpenAISession.shared.AsyncResponse(
            url,
            payload: payload,
            requestOptions: nil,
            client: client,
            method: .post
        )
        print(response)
    }
    @Test mutating func asyncStream() async throws {
        payload.stream = true
        let Streram: AsyncThrowingStream<BaseType, Error> = try await OpenAISession.shared.AsyncStreamResponse(
            url,
            payload: payload,
            requestOptions: nil,
            client: client,
            method: .post
        )
        for try await result in Streram {
            print(result)
        }
    }
}

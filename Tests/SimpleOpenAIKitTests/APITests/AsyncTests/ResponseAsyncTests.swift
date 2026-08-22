//
//  ResponseAsyncTests.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Testing
import Foundation
@testable import SimpleOpenAIKit

@Suite("ResponseAsyncTests")
struct ResponseAsyncTests {
    let param: ResponseCreateParameters = .init(
        model: "deepseek-v4-flash",
        input: "who are you?",
    )
    @Test func asyncResponseData() async throws {
        let res = try await asyncClient.responses.create(
            parameters: param,
        )
        print(res)
        print()
        print(res.output_text)
    }
    @Test func asyncResponseStream() async throws {
        let res = try await asyncClient.responses.stream(
            parameters: param
        )
        for try await chunk in res {
            print(chunk)
        }
    }
    
    @Test func asyncWebSearchTest() async throws {
        let res = try await asyncClient.responses.stream(
            parameters: .init(
                model: "qwen3.8-max",
                input: "法国现任总统是谁?",
                tools: [.web_search],
            ),
        )
        for try await chunk in res {
            print(chunk)
        }
    }
    func asyncMultiResponseStream(id: String) async throws {
        let res = try await asyncClient.responses.stream(
            parameters: param
        )
        for try await chunk in res {
            print("======" + id + "======")
            print(chunk)
        }
    }
    @Test func test() async throws {
        async let t1 = asyncMultiResponseStream(id: "1")
        async let t2 = asyncMultiResponseStream(id: "2")
        
        let _ = try await t1
        let _ = try await t2
    }
}

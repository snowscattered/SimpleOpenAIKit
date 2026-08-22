//
//  ResponseSyncTests.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Testing
import Foundation
@testable import SimpleOpenAIKit

@Suite("ResponseSyncTests")
struct ResponseSyncTests {
    let param: ResponseCreateParameters = .init(
        model: "deepseek-v4-pro",
        input: "你是谁？",
    )
    @Test func syncResponseData() throws {
        let res = try client.responses.create(
            parameters: param,
        )
        print(res)
        print()
        print(res.output_text)
    }
    @Test func syncResponseStream() throws {
        let res = try client.responses.stream(
            parameters: param
        )
        try res.forEach { chunk in
            print(chunk)
        }
    }
    
    @Test func WebSearchTest() throws {
        let res = try client.responses.stream(
            parameters: .init(
                model: "qwen3.8-max",
                input: "法国现任总统是谁?",
                tools: [.web_search],
//                tools: [["type": "web_search"]],
            ),
        )
        try res.forEach { chunk in
            print(chunk)
        }
        
    }
}

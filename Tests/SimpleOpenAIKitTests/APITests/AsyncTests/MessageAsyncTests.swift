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
        model: "deepseek-v4-flash",
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
    struct Tool: ToolProtocol {
        static let name: String = "fetch_weather"
        static let description: String = "Fetch the weather for a given location."
        static let strict: Bool? = true
        @ReferArgument
        struct Location {
            let lat: Float
            let long: Float
        }
        @MainArgument
        struct Argument {
            @ReferToolArgument(description: "The location to fetch the weather for.")
            let location: Location
            let time: Double
        }
        static func call(arguments: Argument) async throws -> String { "sunny" }
    }
    @Test func asyncResponseToolData() async throws {
        var parameters = param
        parameters.messages = [.user("Could you fetch the current weather for lat=40.7128, lon=-74.0060? Also tell me what it'll be like in 5 hours.")]
        parameters.tools = [.init(Tool.self)]
        let res = try await anthropicAsyncClient.messages.create(
            parameters: parameters
        )
        print(res)
        for block in res.content {
            switch block {
            case .tool_use(let tool_use_block):
                let data = try JSONEncoder().encode(tool_use_block.input)
                let arg = try JSONDecoder().decode(Tool.Argument.self, from: data)
                print(arg)
            default: continue
            }
        }
    }
    @Test func asyncResponseToolStrean() async throws {
        var parameters = param
        parameters.messages = [.user("Could you fetch the current weather for lat=40.7128, lon=-74.0060? Also tell me what it'll be like in 5 hours.")]
        parameters.tools = [.init(Tool.self)]
        let res = try await anthropicAsyncClient.messages.stream(
            parameters: parameters
        )
        for try await chunk in res {
            print(chunk)
        }
    }
}

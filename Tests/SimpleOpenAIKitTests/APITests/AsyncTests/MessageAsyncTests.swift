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
        struct Arguments {
            @ReferToolArgument(description: "The location to fetch the weather for.")
            let location: Location
            let time: Double
        }
        static func call(arguments: Arguments) async throws -> String { "sunny" }
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
                let arg = try JSONDecoder().decode(Tool.Arguments.self, from: data)
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
    
    @ReferArgument
    struct Location {
        let lat: Float
        let long: Float
    }
    @MainArgument(
        description: "Fetch the weather for a given location.",
        strict: true
    )
    struct Schema: SchemaProtocol {
        @ReferToolArgument(description: "The location to fetch the weather for.")
        let location: Location
        let time: Double
    }
    @Test func asyncMessageSchemaData() async throws {
        var parameters = param
        parameters.messages = [.user("Could you fetch the current weather for lat=40.7128, lon=-74.0060? Also tell me what it'll be like in 5 hours.")]
        parameters.tools = nil
        parameters.output_config = MessageOutputConfig(format: MessageJSONOutputFormat(Schema.self))
        let res = try await anthropicAsyncClient.messages.create(
            parameters: parameters
        )
        print(res)
        for block in res.content {
            switch block {
            case .text(let text_block):
                let arg = try JSONDecoder().decode(Schema.self, from: text_block.text.data(using: .utf8)!)
                print(arg)
            default: continue
            }
        }
    }
    @Test func asyncMessageSchemaStream() async throws {
        var parameters = param
        parameters.messages = [.user("Could you fetch the current weather for lat=40.7128, lon=-74.0060? Also tell me what it'll be like in 5 hours.")]
        parameters.tools = nil
        parameters.output_config = MessageOutputConfig(format: MessageJSONOutputFormat(Schema.self))
        let res = try await anthropicAsyncClient.messages.stream(
            parameters: parameters
        )
        var content = ""
        for try await chunk in res {
            if case .content_block_delta(let event) = chunk, case .text_delta(let delta) = event.delta {
                content += delta.text
                print(delta.text, terminator: "")
            }
        }
        print()
        let arg = try JSONDecoder().decode(Schema.self, from: content.data(using: .utf8)!)
        print(arg)
    }
}

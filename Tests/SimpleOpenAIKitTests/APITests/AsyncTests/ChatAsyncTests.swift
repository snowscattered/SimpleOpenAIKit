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
        model: "deepseek-v4-flash",
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
    @Test func asyncChatToolData() async throws {
        var parameters = param
        parameters.messages = [.user("Could you fetch the current weather for lat=40.7128, lon=-74.0060? Also tell me what it'll be like in 5 hours.")]
        parameters.tools = [.init(Tool.self)]
        let res = try await asyncClient.chat.completions.create(
            parameters: parameters
        )
        print(res)
        if let tool_calls = res.choices.first?.message.tool_calls {
            for tool_call in tool_calls {
                switch tool_call {
                case .function(let function):
                    let str = function.function.arguments
                    let arg = try JSONDecoder().decode(Tool.Arguments.self, from: str.data(using: .utf8)!)
                    print(arg)
                default: continue
                }
            }
        }
    }
    @Test func asyncChatToolStream() async throws {
        var parameters = param
        parameters.messages = [.user("Could you fetch the current weather for lat=40.7128, lon=-74.0060? Also tell me what it'll be like in 5 hours.")]
        parameters.tools = [.init(Tool.self)]
        let res = try await asyncClient.chat.completions.stream(
            parameters: parameters
        )
        for try await chunk in res {
            print(chunk)
        }
    }
    
    @ReferSchema
    struct Location {
        let lat: Float
        let long: Float
    }
    @MainSchema(
        description: "Fetch the weather for a given location.",
        strict: true
    )
    struct Schema: SchemaProtocol {
        @ReferToolArgument(description: "The location to fetch the weather for.")
        let location: Location
        let time: Double
    }
    @Test func asyncChatSchemaData() async throws {
        var parameters = param
        parameters.messages = [.user("Could you fetch the current weather for lat=40.7128, lon=-74.0060? Also tell me what it'll be like in 5 hours.")]
        parameters.response_format = ChatResponseFormat(Schema.self)
        let res = try await asyncClient.chat.completions.create(
            parameters: parameters,
        )
        print(res)
        if case .string(let content)? = res.choices.first?.message.content {
            let arg = try JSONDecoder().decode(Schema.self, from: content.data(using: .utf8)!)
            print(arg)
        }
    }
    @Test func asyncChatSchemaStream() async throws {
        var parameters = param
        parameters.messages = [.user("Could you fetch the current weather for lat=40.7128, lon=-74.0060? Also tell me what it'll be like in 5 hours.")]
        parameters.response_format = ChatResponseFormat(Schema.self)
        let res = try await asyncClient.chat.completions.stream(
            parameters: parameters
        )
        var content = ""
        for try await chunk in res {
            if let delta = chunk.choices.first?.delta.content {
                content += delta
                print(delta, terminator: "")
            }
        }
        print()
        let arg = try JSONDecoder().decode(Schema.self, from: content.data(using: .utf8)!)
        print(arg)
    }
}

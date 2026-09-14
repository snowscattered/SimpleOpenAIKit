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
        parameters.input = "Could you fetch the current weather for lat=40.7128, lon=-74.0060? Also tell me what it'll be like in 5 hours."
        parameters.tools = [.init(Tool.self)]
        let res = try await asyncClient.responses.create(
            parameters: parameters
        )
        print(res)
        for item in res.output {
            switch item {
            case .function_call(let function_call_item):
                let str = function_call_item.arguments
                let arg = try JSONDecoder().decode(Tool.Argument.self, from: str.data(using: .utf8)!)
                print(arg)
            default: continue
            }
        }
    }
    @Test func asyncResponseToolStrean() async throws {
        var parameters = param
        parameters.input = "Could you fetch the current weather for lat=40.7128, lon=-74.0060? Also tell me what it'll be like in 5 hours."
        parameters.tools = [.init(Tool.self)]
        let res = try await asyncClient.responses.stream(
            parameters: parameters
        )
        for try await chunk in res {
            print(chunk)
        }
    }
}

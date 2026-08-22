//
//  ConnectionTests.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/28/26.
//
import Testing
import Foundation
import SimpleCodableMacro
@testable import SimpleOpenAIKit

@Suite("Connention")
struct ConnectionTests {
    func makeCompletionRequest() throws -> URLRequest {
        let url: URL = URL(string: "https://api.deepseek.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(client.api_key)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "model": "deepseek-v4-pro",
            "stream": true,
            "messages": [ ["role": "user", "content": "用中文写两句诗"] ]
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        return request
    }
    
    func makeResponsesRequest() throws -> URLRequest {
        let url: URL = URL(string: "http://localhost:25000/v1/responses")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(client.api_key)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
            "model": "deepseek-v4-pro",
            "stream": true,
            "input": "用中文写两句诗"
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        return request
    }
    
    @Test func AsyncDataConnection() async throws {
        let data: Data = try await URLSession.shared.asyncData(try makeCompletionRequest())
        print(String(data: data, encoding: .utf8) ?? "No data")
    }
    @Test func AsyncSSEConnection() async throws {
        let data = try await URLSession.shared.asyncSSE(try makeCompletionRequest())
        for try await value in data {
            print(value)
        }
    }
    @Test func SyncDataConnection() throws {
        let data: Data = try URLSession.shared.syncData(try makeCompletionRequest())
        print(String(data: data, encoding: .utf8) ?? "No data")
    }
    @Test func SyncSSEConnection() throws {
        let data = try URLSession.shared.syncSSE(try makeCompletionRequest())
        data.forEach { value in
            print(value)
        }
    }
    
    
    actor Counter {
        private var value = 0
        func increment() { value += 1 }
        func get() -> Int { value }
    }
    @Test func retryConnection() async throws {
        let counter = Counter()
        _ = try await retry(maxRetries: 3) {
            await counter.increment()
            return try await URLSession.shared.asyncData(try makeCompletionRequest())
        }
        print(await counter.get())
    }
}

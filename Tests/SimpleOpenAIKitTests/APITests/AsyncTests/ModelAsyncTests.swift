//
//  ModelAsyncTests.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Testing
import Foundation
@testable import SimpleOpenAIKit

@Suite("ModelAsyncTests")
struct ModelAsyncTests {
    @Test func asyncModelList() async throws {
        let res = try await asyncClient.models.list()
        for i in res.data {
            print(i)
        }
    }
    @Test func asyncModel() async throws {
        let res = try await asyncClient.models.retrieve(model: "deepseek-v4-flash")
        print(res)
    }
}

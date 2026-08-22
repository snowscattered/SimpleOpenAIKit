//
//  ModelSyncTests.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Testing
import Foundation
@testable import SimpleOpenAIKit

@Suite("ModelSyncTests")
struct ModelSyncTests {
    @Test func syncModelList() throws {
        let res = try client.models.list()
        for i in res.data {
            print(i)
        }
    }
    @Test func syncModel() throws {
        let res = try client.models.retrieve(model: "deepseek-v4-flash")
        print(res)
    }
}

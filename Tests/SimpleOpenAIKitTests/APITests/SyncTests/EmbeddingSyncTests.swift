//
//  EmbeddingSyncTests.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/17/26.
//

import Testing
import Foundation
@testable import SimpleOpenAIKit

@Suite("EmbeddingSyncTests")
struct EmbeddingSyncTests {
    @Test func syncEmbeddingTests() throws {
        let res = try client.embeddings.create(
            parameters: .init(model: "", input: "This is a Text", dimensions: 1024)
        )
        print(res.data.first?.embedding.count ?? "No Data")
    }
}

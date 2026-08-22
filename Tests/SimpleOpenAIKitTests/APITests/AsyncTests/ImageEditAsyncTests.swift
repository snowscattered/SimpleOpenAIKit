//
//  ImageEditAsyncTests.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/6/26.
//

import Testing
import Foundation
@testable import SimpleOpenAIKit

@Suite("ImageEditAsyncTests")
struct ImageEditAsyncTests {
    let parameters: ImageEditParameters = .init(
        model: "gpt-image-2",
        prompt: "",
        image: [
//            FileParameters(URL(""))
        ]
    )
    @Test func asyncImageEditTests() async throws {
        let res = try await asyncClient.images.edit(
            parameters: parameters
        )
        print(res)
    }
}

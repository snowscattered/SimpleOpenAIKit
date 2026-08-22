//
//  ImageGenerateAsyncTests.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/17/26.
//

import Testing
import Foundation
@testable import SimpleOpenAIKit

@Suite("ImageGenerateAsyncTests")
struct ImageGenerateAsyncTests {
    let parameters: ImageGenerateParameters = .init(
        model: "glm-image",
        prompt: "一只可爱的小猫咪，坐在阳光明媚的窗台上，背景是蓝天白云",
        size: "1280x1280"
    )
    @Test func asyncImageGenerateTests() async throws {
        let res = try await asyncClient.images.generate(
            parameters: parameters
        )
        print(res)
    }
}

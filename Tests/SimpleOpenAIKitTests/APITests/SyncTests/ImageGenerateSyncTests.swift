//
//  ImageGenerateSyncTests.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/17/26.
//

import Testing
import Foundation
@testable import SimpleOpenAIKit

@Suite("ImageGenerateSyncTests")
struct ImageGenerateSyncTests {
    let parameters: ImageGenerateParameters = .init(
        model: "glm-image",
        prompt: "一只可爱的小猫咪，坐在阳光明媚的窗台上，背景是蓝天白云",
        size: "1280x1280"
    )
    @Test func syncImageGenerateTests() throws {
        let res = try client.images.generate(
            parameters: parameters
        )
        print(res)
    }
}

//
//  ImageEditSyncTests.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/6/26.
//

import Testing
import Foundation
@testable import SimpleOpenAIKit

@Suite("ImageEditSyncTests")
struct ImageEditSyncTests {
    let parameters: ImageEditParameters = .init(
        model: "gpt-image-2",
        prompt: "",
        image: [
//            FileParameters(URL(""))
        ]
    )
    @Test func syncImageGenerateTests() throws {
        let res = try client.images.edit(
            parameters: parameters
        )
        print(res)
    }
}

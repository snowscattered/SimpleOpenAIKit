//
//  AudioTranscriptionsSyncTests.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/13/26.
//

import Testing
import Foundation
@testable import SimpleOpenAIKit

@Suite("AudioTranscriptionsSyncTests")
struct AudioTranscriptionsSyncTests {
    func makeRequest() throws -> AudioTranscriptionParameters {
        let url = try #require(bundle.url(forResource: "refer", withExtension: "wav"))
        return try .init(
            model: "glm-asr-2512",
            file: .init(url: url),
        )
    }
    
    @Test func syncAudioTranscriptionsData() throws {
        let res = try client.audio.transcriptions.create(
            parameters: makeRequest()
        )
        print(res)
    }
    
    @Test func syncAudioTranscriptionsStream() throws {
        let res = try client.audio.transcriptions.stream(
            parameters: makeRequest()
        )
        try res.forEach { chunk in
            print(chunk)
        }
    }
}

//
//  AudioTranscriptionsAsyncTests.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/13/26.
//

import Testing
import Foundation
@testable import SimpleOpenAIKit

@Suite("AudioTranscriptionsAsyncTests")
struct AudioTranscriptionsAsyncTests {
    func makeRequest() throws -> AudioTranscriptionParameters {
        let url = try #require(bundle.url(forResource: "refer", withExtension: "wav"))
        return try .init(
            model: "glm-asr-2512",
            file: .init(url: url),
        )
    }
    
    @Test func asyncAudioTranscriptionsData() async throws {
        let res = try await asyncClient.audio.transcriptions.create(
            parameters: makeRequest()
        )
        print(res)
    }
    
    @Test func asyncAudioTranscriptionsStream() async throws {
        let res = try await asyncClient.audio.transcriptions.stream(
            parameters: makeRequest()
        )
        for try await chunk in res {
            print(chunk)
        }
    }
}

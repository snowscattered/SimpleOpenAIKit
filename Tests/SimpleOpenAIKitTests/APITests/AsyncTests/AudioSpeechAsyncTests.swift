//
//  AudioSpeechAsyncTests.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/17/26.
//

import Testing
import Foundation
@testable import SimpleOpenAIKit

@Suite("AudioSpeechAsyncTests")
struct AudioSpeechAsyncTests {
    let param: AudioSpeechParameters = .init(
        model: "glm-tts",
        input: "人间灯火倒映湖中，她的渴望让静水泛起涟漪。若代价只是孤独，那就让这份愿望肆意流淌…流入她所注视的世间，也流入她如湖水般澄澈的目光",
        voice: "female",
        response_format: .wav,
        speed: 1.0,
    )
    let url = bundle.url(forResource: "TTS", withExtension: "wav")!
    @Test func asyncAudioSpeechData() async throws {
        let res = try await asyncClient.audio.speech.create(
            parameters: param,
        )
        try res.write(to: url)
    }
    @Test func asyncAudioSpeechStream() async throws {
        let res = try await asyncClient.audio.speech.stream(
            parameters: param,
        )
        var i = 0
        for try await chunk in res {
            if i == 0 {
                print(ContinuousClock.now)
            }
            print(chunk.count)
            i += chunk.count
        }
        print(i)
        print(ContinuousClock.now)
    }
}

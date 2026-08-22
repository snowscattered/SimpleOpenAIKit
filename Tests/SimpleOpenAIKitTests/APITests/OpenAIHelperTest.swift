//
//  OpenAIHelperTest.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/12/26.
//

import Testing
import Foundation
import AVFoundation
@testable import SimpleOpenAIKit

@Suite("OpenAIHelperTest")
struct OpenAIHelperTest {
    @Test func MicrophoneHelperTest() async throws {
        let format = AudioFormat(
            sampleRate: 24_000,
            channelCount: 1,
            bitDepth: .pcmFormatInt16,
            interleaved: false
        )
        let helper: MicrophoneHelper = AVMicrophoneHelper(
            targetFormat: format,
            timeout: 5
        )
        let player = AVAudioPlayerHelper(
            targetFormat: format
        )
        let data: Data = try await helper.record()
        print(data.count)
        
        print(Date())
        try await player.play(data)
        print(Date())
    }

    @Test func AudioPlayerTest() async throws {
        let url = try #require(bundle.url(forResource: "refer", withExtension: "wav"))
        let player = AVAudioPlayerHelper(targetFormat: .init(
            sampleRate: 48_000,
            channelCount: 1,
            bitDepth: .pcmFormatInt16,
            interleaved: true
        ))
        let data = try Data(contentsOf: url)
        try await player.play(data)
        
//        let format = AVAudioFormat(
//            commonFormat: .pcmFormatInt16,
//            sampleRate: 48_000,
//            channels: 1,
//            interleaved: false
//        )!
//        let data = try Data(contentsOf: url)
//        guard let pcmData = extractPCMDataSimple(from: data) else { return }
//        guard let pcm = makeBuffer(from: data, format: format) else { return }
//        print("Star")
//        let engine = AVAudioEngine()
//        let player = AVAudioPlayerNode()
//        engine.attach(player)
//        engine.connect(player, to: engine.mainMixerNode, format: format)
//        engine.connect(engine.mainMixerNode, to: engine.outputNode, format: nil)
//
//        try engine.start()
//        defer { engine.stop() }
//        player.play()
//        await player.scheduleBuffer(pcm)
//        player.stop()
    }
}

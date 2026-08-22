//
//  RealtimeAsyncTests.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/11/26.
//

import Testing
import Foundation
import AVFoundation
@testable import SimpleOpenAIKit

@Suite("RealtimeAsyncTests")
struct RealtimeAsyncTests {
    @Test func asyncRealtime() async throws {
        try await asyncClient.realtime.conntent(model: "qwen3.5-omni-flash") { connect in
            try await connect.session.update(session: .realtime(.init(
                model: "gpt-realtime",
                instructions: "",
                audio: .init(
                    input: .init(format: .pcm),
                    output: .init(format: .pcm)
                ),
            )))
            Task {
                do {
                    let helper: MicrophoneHelper = AVMicrophoneHelper(
                        targetFormat: .init(
                            sampleRate: 24_000,
                            channelCount: 1,
                            bitDepth: .pcmFormatInt16,
                            interleaved: false
                        ),
                        timeout: 5
                    )
                    let data: Data = try await helper.record()
                    try await connect.input_audio_buffer.append(audio: data.base64EncodedString())
                } catch { }
            }
            Task {
                for await event in connect {
                    print(event)
                }
            }
            try await Task.sleep(seconds: 15)
        }
    }
    
    @Test func asyncBetaRealtime() async throws {
        try await asyncClient.beta.realtime.conntent(model: "qwen3.5-omni-flash") { connect in
            try await connect.session.update(session: .init(
                model: "gpt-realtime",
                input_audio_format: "pcm16",
                instructions: "You ara a friendly AI assistant.",
                modalities: [.audio, .text],
                turn_detection: .init(
                    type: .server_vad,
                    threshold: 0.5,
                    silence_duration_ms: 800,
                ),
                voice: "Tina",
            ))
            Task {
                do {
                    let helper: MicrophoneHelper = AVMicrophoneHelper(
                        targetFormat: .init(
                            sampleRate: 24_000,
                            channelCount: 1,
                            bitDepth: .pcmFormatInt16,
                            interleaved: false
                        ),
                        timeout: 5
                    )
                    let data: Data = try await helper.record()
                    try await connect.input_audio_buffer.append(audio: data.base64EncodedString())
                } catch { }
            }
            Task {
                for await event in connect {
                    print(event)
                }
            }
            try await Task.sleep(seconds: 15)
        }
    }
}

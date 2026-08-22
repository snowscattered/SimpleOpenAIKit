//
//  OpenAIHelper.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/11/26.
//

import Foundation

public let BufferSize: AVAudioFrameCount = 1024
public struct AudioFormat: Hashable, Sendable {
    public var sampleRate: Double
    public var channelCount: UInt32
    public var bitDepth: BitDepth
    public var interleaved: Bool

    public enum BitDepth: UInt, Hashable, Sendable {
        case otherFormat      = 0
        case pcmFormatFloat32 = 1
        case pcmFormatFloat64 = 2
        case pcmFormatInt16   = 3
        case pcmFormatInt32   = 4
    }
    public init(
        sampleRate: Double,
        channelCount: UInt32,
        bitDepth: BitDepth = .pcmFormatFloat32,
        interleaved: Bool = true
    ) {
        self.sampleRate = sampleRate
        self.channelCount = channelCount
        self.bitDepth = bitDepth
        self.interleaved = interleaved
    }
}
protocol MicrophoneHelper: Sendable {
    init (
        targetFormat: AudioFormat?,
        shouldRecord: (@Sendable () async -> Bool)?,
        timeout: TimeInterval?
    )
    func record() async throws -> Data
    func record() async throws -> AsyncStream<Data>
}
protocol AudioPlayerHelper: Sendable {
    init (
        targetFormat: AudioFormat?,
        shouldStop: (@Sendable () async -> Bool)?
    )
    func play(_ data: Data) async throws
    func play(_ url: URL) async throws
    func play(_ stream: AsyncStream<Data>) async throws
}

#if canImport(AVFoundation)
import AVFoundation

extension AudioFormat {
    public init(_ av: AVAudioFormat) {
        self.init(
            sampleRate: av.sampleRate,
            channelCount: av.channelCount,
            bitDepth: BitDepth(rawValue: av.commonFormat.rawValue) ?? .otherFormat,
            interleaved: av.isInterleaved
        )
    }
    public func makeAVAudioFormat() -> AVAudioFormat? {
        guard let common = AVAudioCommonFormat(rawValue: bitDepth.rawValue) else {
            return nil
        }
        if common == .pcmFormatFloat32 && !interleaved {
            return AVAudioFormat(
                standardFormatWithSampleRate: sampleRate,
                channels: channelCount
            )
        }
        return AVAudioFormat(
            commonFormat: common,
            sampleRate: sampleRate,
            channels: channelCount,
            interleaved: interleaved
        )
    }
}


private func convert(
    _ buffer: AVAudioPCMBuffer,
    converter: AVAudioConverter?,
) -> Data? {
    let outputBuffer: AVAudioPCMBuffer
    if let converter {
        let frameCapacity = max(
            AVAudioFrameCount(Double(buffer.frameLength) * converter.outputFormat.sampleRate / buffer.format.sampleRate),
            buffer.frameLength
        )
        guard let convertedBuffer = AVAudioPCMBuffer(pcmFormat: converter.outputFormat, frameCapacity: frameCapacity) else {
            return nil
        }
        
        var error: NSError?
        let status = converter.convert(to: convertedBuffer, error: &error) { _, outStatus in
            outStatus.pointee = .haveData
            return buffer
        }
        guard status != .error, error == nil else { return nil }
        outputBuffer = convertedBuffer
    } else {
        outputBuffer = buffer
    }
    let byteSize = Int(outputBuffer.audioBufferList.pointee.mBuffers.mDataByteSize)
    guard byteSize > 0, let bytes = outputBuffer.audioBufferList.pointee.mBuffers.mData else {
        return nil
    }
    return Data(bytes: bytes, count: byteSize)
}
// MARK: - Microphone
public final class AVMicrophoneHelper: MicrophoneHelper {
    private let targetFormat: AVAudioFormat?
    private let shouldRecord: @Sendable () async -> Bool
    private let timeout: TimeInterval?
    public init(
        targetFormat: AudioFormat? = nil,
        shouldRecord: (@Sendable () async -> Bool)? = nil,
        timeout: TimeInterval? = nil
    ) {
        self.targetFormat = targetFormat?.makeAVAudioFormat()
        self.shouldRecord = shouldRecord ?? { true }
        self.timeout = timeout
    }
    
    enum RecordingError: Error, LocalizedError {
        case timeout
        case stoppedByUser
        
        var errorDescription: String? {
            switch self {
            case .timeout: return "Recording timed out"
            case .stoppedByUser: return "Recording stopped by external signal"
            }
        }
    }
    public func record() async throws -> Data {
        guard await shouldRecord() else { return Data() }
        var result = Data()
        let deadline = timeout.map { Date().addingTimeInterval($0) }
        for await chunk in try await self.record() {
            if let deadline, Date() >= deadline { break }
            result.append(chunk)
        }
        return result
    }
    
    public func record() async throws -> AsyncStream<Data> {
        let engine = AVAudioEngine()
        let input = engine.inputNode
        let sourceFormat = input.outputFormat(forBus: 0)
        let recordingFormat = self.targetFormat ?? sourceFormat
        let converter: AVAudioConverter? = (sourceFormat != recordingFormat)
            ? AVAudioConverter(from: sourceFormat, to: recordingFormat)
            : nil
        let (stream, continuation) = AsyncStream<Data>.makeStream()
        let task = Task.detached(priority: .background) {
            while await self.shouldRecord() {
                try await Task.sleep(nanoseconds: 50_000_000)
            }
            continuation.finish()
        }
        input.installTap(onBus: 0, bufferSize: BufferSize, format: sourceFormat) { buffer, _ in
            if let data = convert(buffer, converter: converter) {
                continuation.yield(data)
            }
        }
        try engine.start()
        continuation.onTermination = { _ in
            input.removeTap(onBus: 0)
            engine.stop()
            task.cancel()
        }
        return stream
    }
}


private func makeBuffer(from data: Data, format: AVAudioFormat) -> AVAudioPCMBuffer? {
    let bytesPerFrame = format.streamDescription.pointee.mBytesPerFrame
    let frameCount = AVAudioFrameCount(data.count) / bytesPerFrame
    guard frameCount > 0,
          let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
        return nil
    }
    buffer.frameLength = frameCount
    data.withUnsafeBytes { raw in
        guard let src = raw.baseAddress else { return }
        UnsafeMutableRawPointer(buffer.audioBufferList.pointee.mBuffers.mData!)
            .copyMemory(from: src, byteCount: data.count)
    }
    return buffer
}
// MARK: - Player
public final class AVAudioPlayerHelper: AudioPlayerHelper {
    private let targetFormat: AVAudioFormat?
    private let shouldStop: @Sendable () async -> Bool
    public init(
        targetFormat: AudioFormat? = nil,
        shouldStop: (@Sendable () async -> Bool)? = nil
    ) {
        self.targetFormat = targetFormat?.makeAVAudioFormat()
        self.shouldStop = shouldStop ?? { false }
    }
    
    public enum PlaybackError: Error, LocalizedError {
        case targetFormatRequired
        case invalidData

        public var errorDescription: String? {
            switch self {
            case .targetFormatRequired:
                return "targetFormat is required for raw Data / AsyncStream playback"
            case .invalidData:
                return "Failed to create PCM buffer from data"
            }
        }
    }
    public func play(_ data: Data) async throws {
        guard let format = targetFormat else { throw PlaybackError.targetFormatRequired }
        let bytesPerFrame = format.streamDescription.pointee.mBytesPerFrame
        guard bytesPerFrame > 0 else { throw PlaybackError.invalidData }
        let chunkBytes = Int(BufferSize * bytesPerFrame)
        let stream = AsyncStream<AVAudioPCMBuffer> { continuation in
            var offset = 0
            while offset < data.count {
                let end = min(offset + chunkBytes, data.count)
                let slice = Data(data[offset..<end])
                if let buffer = makeBuffer(from: slice, format: format) {
                    continuation.yield(buffer)
                }
                offset = end
            }
            continuation.finish()
        }
        try await play(stream)
    }
    public func play(_ url: URL) async throws {
        let file = try AVAudioFile(forReading: url)
        let format = targetFormat ?? file.processingFormat
        let stream = AsyncStream<AVAudioPCMBuffer> { continuation in
            while file.framePosition < file.length {
                guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: BufferSize) else {
                    continuation.finish()
                    return
                }
                do {
                    try file.read(into: buffer, frameCount: min(BufferSize, AVAudioFrameCount(file.length - file.framePosition)))
                } catch {
                    continuation.finish()
                    return
                }
                if buffer.frameLength == 0 { break }
                continuation.yield(buffer)
            }
            continuation.finish()
        }
        try await play(stream)
    }
    public func play(_ stream: AsyncStream<Data>) async throws {
        guard let format = targetFormat else { throw PlaybackError.targetFormatRequired }
        let bufferStream = AsyncStream<AVAudioPCMBuffer> { continuation in
            Task {
                for await chunk in stream {
                    if let buffer = makeBuffer(from: chunk, format: format) {
                        continuation.yield(buffer)
                    }
                }
                continuation.finish()
            }
        }
        try await play(bufferStream)
        
    }
    
    private func play(_ stream: AsyncStream<AVAudioPCMBuffer>) async throws {
        let engine = AVAudioEngine()
        let player = AVAudioPlayerNode()
        engine.attach(player)
        var iterator = stream.makeAsyncIterator()
        guard let first = await iterator.next() else { return }
        
        engine.connect(player, to: engine.mainMixerNode, format: first.format)
        engine.connect(engine.mainMixerNode, to: engine.outputNode, format: nil)

        try engine.start()
        defer { engine.stop() }
        player.play()
        await player.scheduleBuffer(first)
        for await buffer in stream {
            try Task.checkCancellation()
            if await shouldStop() { break }
            await player.scheduleBuffer(buffer)
        }
        player.stop()
    }
}
private func appendLittleEndian<T: FixedWidthInteger>(_ value: T, to data: inout Data) {
    var littleEndian = value.littleEndian
    withUnsafeBytes(of: &littleEndian) { bytes in
        data.append(contentsOf: bytes)
    }
}
private func makeWAVData(data: Data, format: AVAudioFormat) throws -> Data {
    enum CovertError: Error {
        case invalidAudioFormat
        case invalidAudioData
    }
    let streamDescription = format.streamDescription.pointee
    let channels = Int(streamDescription.mChannelsPerFrame)
    let sampleRate = streamDescription.mSampleRate
    let bitsPerSample = Int(streamDescription.mBitsPerChannel)
    let bytesPerSample = bitsPerSample / 8
    let blockAlign = channels * bytesPerSample

    guard channels > 0, sampleRate > 0, bytesPerSample > 0, blockAlign > 0,
          data.count.isMultiple(of: blockAlign) else {
        throw CovertError.invalidAudioData
    }
    guard format.isInterleaved || channels == 1 else {
        throw CovertError.invalidAudioFormat
    }

    let wavFormat: UInt16
    switch format.commonFormat {
    case .pcmFormatFloat32, .pcmFormatFloat64:
        wavFormat = 3
    case .pcmFormatInt16, .pcmFormatInt32:
        wavFormat = 1
    default:
        throw CovertError.invalidAudioFormat
    }

    var wav = Data()
    wav.append(contentsOf: Array("RIFF".utf8))
    appendLittleEndian(Int32(36 + data.count), to: &wav)
    wav.append(contentsOf: Array("WAVE".utf8))
    wav.append(contentsOf: Array("fmt ".utf8))
    appendLittleEndian(UInt32(16), to: &wav)
    appendLittleEndian(wavFormat, to: &wav)
    appendLittleEndian(UInt16(channels), to: &wav)
    appendLittleEndian(UInt32(sampleRate), to: &wav)
    appendLittleEndian(UInt32(sampleRate * Double(blockAlign)), to: &wav)
    appendLittleEndian(UInt16(blockAlign), to: &wav)
    appendLittleEndian(UInt16(bitsPerSample), to: &wav)
    wav.append(contentsOf: Array("data".utf8))
    appendLittleEndian(UInt32(data.count), to: &wav)
    wav.append(data)
    return wav
}
#endif

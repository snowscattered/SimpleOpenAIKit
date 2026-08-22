//
//  DataExtension.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/9/26.
//

import Foundation
import System

extension Data {
    package mutating func read() -> Data {
        return self
    }
    package mutating func read(size: Int) -> Data? {
        guard !self.isEmpty else { return nil }
        let end = Swift.min(size, self.count)
        let chunk = Data(self.prefix(end))
        self = Data(self.dropFirst(end))
        return chunk
    }
}
// MARK: IO API
extension Stream {
    @inlinable
    func with(call: () throws -> Void) rethrows {
        self.open()
        defer { self.close() }
        try call()
    }
    
    @inlinable
    func with(call: () async throws -> Void) async rethrows {
        self.open()
        defer { self.close() }
        try await call()
    }
}
extension InputStream {
    func read() -> Data {
        var result = Data()
        let bufferSize = 16 * 1024
        var buffer = [UInt8](repeating: 0, count: bufferSize)
        while self.hasBytesAvailable {
            let bytesRead = self.read(&buffer, maxLength: bufferSize)
            if bytesRead > 0 {
                result.append(buffer, count: bytesRead)
            } else { break }
        }
        return result
    }
    func read(size: Int) -> Data {
        var buffer = [UInt8](repeating: 0, count: size)
        let bytesRead = self.read(&buffer, maxLength: size)
        if bytesRead > 0 {
            return Data(buffer.prefix(bytesRead))
        } else { return Data() }
    }
}
extension OutputStream {
    func write(data: Data) throws {
        try data.withUnsafeBytes { rawBuffer in
            guard let base = rawBuffer.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                throw IOStreamError.invalidData
            }
            var offset = 0
            let total = data.count
            while offset < total {
                let remaining = total - offset
                let written = self.write(base + offset, maxLength: remaining)
                if written < 0 {
                    throw self.streamError ?? IOStreamError.writeFailed
                }
                if written == 0 { break }
                offset += written
            }
        }
    }
    
    func writeFile<T: AsyncSequence>(stream: T) async throws where T.Element == Data {
        for try await chunk in stream {
            try Task.checkCancellation()
            try self.write(data: chunk)
        }
    }
    func writeFile<T: SyncSequence>(stream: T) throws where T.Element == Data {
        try stream.forEach { chunk in
            try Task.checkCancellation()
            try self.write(data: chunk)
        }
    }
}

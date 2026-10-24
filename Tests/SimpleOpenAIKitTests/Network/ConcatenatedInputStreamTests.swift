//
//  ConcatenatedInputStreamTests.swift
//  SimpleOpenAIKit
//

import Foundation
import Testing
@testable import SimpleOpenAIKit

private enum ConcatenatedStubError: Error, Equatable {
    case failed
}

private final class ConcatenatedStubInputStream: InputStream {
    private let readResult: Int
    private let statusAfterOpen: Stream.Status
    private let failure: (any Error)?
    private var status: Stream.Status = .notOpen

    init(
        readResult: Int,
        statusAfterOpen: Stream.Status = .open,
        error: (any Error)? = nil
    ) {
        self.readResult = readResult
        self.statusAfterOpen = statusAfterOpen
        self.failure = error
        super.init(data: Data())
    }

    override var streamStatus: Stream.Status {
        return status
    }

    override var streamError: (any Error)? {
        return failure
    }

    override var hasBytesAvailable: Bool {
        return false
    }

    override func open() {
        if status == .notOpen {
            status = statusAfterOpen
        }
    }

    override func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        return readResult
    }
}

@Suite("ConcatenatedInputStreamTests")
struct ConcatenatedInputStreamTests {
    @Test func readsAcrossStreamsAndReportsEOFOnlyAtTheEnd() throws {
        let stream = ConcatenatedInputStream(streams: [
            InputStream(data: Data("abc".utf8)),
            InputStream(data: Data("de".utf8)),
        ])
        stream.open()

        var buffer = [UInt8](repeating: 0, count: 16)
        let bytesRead = buffer.withUnsafeMutableBufferPointer {
            stream.read($0.baseAddress!, maxLength: $0.count)
        }
        let body = Data(buffer.prefix(bytesRead))

        #expect(body == Data("abcde".utf8))
        #expect(stream.streamStatus == .atEnd)

        let eof = buffer.withUnsafeMutableBufferPointer {
            stream.read($0.baseAddress!, maxLength: $0.count)
        }
        #expect(eof == 0)
        #expect(stream.streamStatus == .atEnd)
    }

    @Test func zeroBeforeMemberEOFBecomesAnError() throws {
        let stream = ConcatenatedInputStream(streams: [
            ConcatenatedStubInputStream(readResult: 0),
        ])
        stream.open()

        var buffer = [UInt8](repeating: 0, count: 8)
        let result = buffer.withUnsafeMutableBufferPointer {
            stream.read($0.baseAddress!, maxLength: $0.count)
        }

        #expect(result == -1)
        #expect(stream.streamStatus == .error)
        #expect(stream.streamError != nil)

        let repeatedResult = buffer.withUnsafeMutableBufferPointer {
            stream.read($0.baseAddress!, maxLength: $0.count)
        }
        #expect(repeatedResult == -1)
    }

    @Test func memberReadFailurePropagatesAsError() throws {
        let expectedError = ConcatenatedStubError.failed
        let stream = ConcatenatedInputStream(streams: [
            ConcatenatedStubInputStream(readResult: -1, error: expectedError),
        ])
        stream.open()

        var buffer = [UInt8](repeating: 0, count: 8)
        let result = buffer.withUnsafeMutableBufferPointer {
            stream.read($0.baseAddress!, maxLength: $0.count)
        }

        #expect(result == -1)
        #expect(stream.streamStatus == .error)
        #expect(stream.streamError as? ConcatenatedStubError == expectedError)
    }
}

//
//  ConcatenatedInputStream.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/10/26.
//

import Foundation

/// An `InputStream` that reads several streams back to back as one continuous body.
///
/// Used by the multipart encoder to glue text headers, file contents and trailers together without
/// buffering the whole payload. Member streams are opened on demand and closed as soon as they drain.
final class ConcatenatedInputStream: InputStream {
    private let streams: [InputStream]
    private var currentIndex = 0
    
    init(streams: [InputStream]) {
        self.streams = streams
        super.init(data: Data())
    }
    
    private var _status: Stream.Status = .notOpen
    override var streamStatus: Stream.Status { return _status }
    private weak var _delegate: (any StreamDelegate)?
    override var delegate: (any StreamDelegate)? {
        get { return _delegate }
        set { _delegate = newValue }
    }
    
    override func open() {
        _status = .open
        if !streams.isEmpty && streams[0].streamStatus == .notOpen {
            streams[0].open()
        }
    }
    override func close() {
        _status = .closed
        for stream in streams where stream.streamStatus != .closed { stream.close() }
    }
    
    override func schedule(in aRunLoop: RunLoop, forMode mode: RunLoop.Mode) {
        if currentIndex < streams.count {
            streams[currentIndex].schedule(in: aRunLoop, forMode: mode)
        }
    }
    override func remove(from aRunLoop: RunLoop, forMode mode: RunLoop.Mode) {
        if currentIndex < streams.count {
            streams[currentIndex].remove(from: aRunLoop, forMode: mode)
        }
    }
    
    /// Fill `buffer` with up to `len` bytes, moving to the next member stream whenever the current one
    /// runs dry. Returns `0` only after the last stream is exhausted, `-1` if the stream is not open.
    override func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        guard _status == .open else { return -1 }
        
        var totalBytesRead = 0
        let targetLength = len
        while totalBytesRead < targetLength && currentIndex < streams.count {
            let stream = streams[currentIndex]
            if stream.streamStatus == .notOpen {
                stream.open()
            }
            let remaining = targetLength - totalBytesRead
            let bytesRead = stream.read(buffer + totalBytesRead, maxLength: remaining)
            
            if bytesRead > 0 {
                totalBytesRead += bytesRead
            } else if bytesRead == 0 {
                stream.close()
                currentIndex += 1
                continue
            } else {
                _status = .error
                return -1
            }
            if bytesRead == 0 && stream.streamStatus != .atEnd && stream.streamStatus != .closed {
                 break
            }
        }
        if totalBytesRead > 0 {
            return totalBytesRead
        }
        if currentIndex >= streams.count {
            _status = .atEnd
            return 0
        }
        return 0
    }
    /// True if any remaining member stream still has bytes, opening them as needed.
    override var hasBytesAvailable: Bool {
        guard _status == .open else { return false }
        for i in currentIndex..<streams.count {
            let stream = streams[i]
            if stream.streamStatus == .notOpen { stream.open() }
            if stream.hasBytesAvailable { return true }
            if stream.streamStatus == .atEnd || stream.streamStatus == .closed {
                stream.close()
                continue
            }
        }
        return false
    }
}

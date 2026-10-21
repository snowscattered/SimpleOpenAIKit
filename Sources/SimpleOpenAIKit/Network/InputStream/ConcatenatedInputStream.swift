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
    private var currentError: (any Error)?
    
    init(streams: [InputStream]) {
        self.streams = streams
        super.init(data: Data())
    }
    
    private var _status: Stream.Status = .notOpen
    override var streamStatus: Stream.Status { return _status }
    private weak var _delegate: (any StreamDelegate)?
    override var streamError: (any Error)? { return currentError }
    override var delegate: (any StreamDelegate)? {
        get { return _delegate }
        set { _delegate = newValue }
    }

    override func property(forKey key: Stream.PropertyKey) -> Any? {
        guard currentIndex < streams.count else { return nil }
        return streams[currentIndex].property(forKey: key)
    }

    override func setProperty(_ property: Any?, forKey key: Stream.PropertyKey) -> Bool {
        guard currentIndex < streams.count else { return false }
        return streams[currentIndex].setProperty(property, forKey: key)
    }

    /// Force CFNetwork to use `read`; a buffer owned by one member stream
    /// cannot safely represent the concatenation across stream boundaries.
    override func getBuffer(
        _ buffer: UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>,
        length len: UnsafeMutablePointer<Int>
    ) -> Bool {
        return false
    }
    
    override func open() {
        guard _status == .notOpen else { return }
        guard currentIndex < streams.count else {
            _status = .atEnd
            return
        }
        _status = .open
        if streams[currentIndex].streamStatus == .notOpen {
            streams[currentIndex].open()
        }
    }
    override func close() {
        guard _status != .closed else { return }
        _status = .closed
        for stream in streams where stream.streamStatus != .closed { stream.close() }
    }
    
    override func schedule(in aRunLoop: RunLoop, forMode mode: RunLoop.Mode) {
        for stream in streams {
            stream.schedule(in: aRunLoop, forMode: mode)
        }
    }
    override func remove(from aRunLoop: RunLoop, forMode mode: RunLoop.Mode) {
        for stream in streams {
            stream.remove(from: aRunLoop, forMode: mode)
        }
    }
    
    /// Fill `buffer` with up to `len` bytes, moving to the next member stream whenever the current one
    /// runs dry. Returns `0` only after the last stream is exhausted, `-1` if the stream is not open.
    override func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        guard len > 0 else { return 0 }
        if _status == .atEnd || _status == .closed { return 0 }
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
                if stream.streamStatus == .atEnd || stream.streamStatus == .closed {
                    stream.close()
                    currentIndex += 1
                    continue
                }
                break
            } else {
                currentError = stream.streamError
                _status = .error
                return -1
            }
        }
        if currentIndex >= streams.count {
            _status = .atEnd
        }
        return totalBytesRead
    }
    /// True if any remaining member stream still has bytes, opening them as needed.
    override var hasBytesAvailable: Bool {
        guard _status == .open else { return false }
        while currentIndex < streams.count {
            let stream = streams[currentIndex]
            if stream.streamStatus == .notOpen { stream.open() }
            if stream.hasBytesAvailable { return true }
            if stream.streamStatus == .atEnd || stream.streamStatus == .closed {
                stream.close()
                currentIndex += 1
                continue
            }
            return false
        }
        _status = .atEnd
        return false
    }
}

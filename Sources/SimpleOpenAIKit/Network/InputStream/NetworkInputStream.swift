//
//  NetworkInputStream.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/10/26.
//

import Foundation

/// An `InputStream` fed by a download task, so a remote URL can be sent as an upload part.
///
/// `open()` starts the task; `read` blocks until the delegate delivers bytes or the transfer ends.
/// The buffer is capped at 64 KB, which also throttles the download.
final class NetworkInputStream: InputStream {
    private let url: URL
    private var task: URLSessionDataTask?
    private var session: URLSession?

    private var buffer = Data(capacity: 64 * 1024)
    private let maxBufferSize = 64 * 1024
    private let resumeThreshold = 32 * 1024
    private var readOffset = 0
    private var isFinished = false
    private var isSuspended = false
    private var _status: Stream.Status = .notOpen
    private var _streamError: (any Error)?
    private weak var _delegate: (any StreamDelegate)?

    private let lock = NSLock()
    private let semaphore = DispatchSemaphore(value: 0)

    override init(url: URL) {
        self.url = url
        super.init(data: Data())
    }

    override var delegate: (any StreamDelegate)? {
        get { _delegate }
        set { _delegate = newValue }
    }

    override func property(forKey key: Stream.PropertyKey) -> Any? {
        return nil
    }

    override func setProperty(_ property: Any?, forKey key: Stream.PropertyKey) -> Bool {
        return false
    }

    override func getBuffer(
        _ buffer: UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>,
        length len: UnsafeMutablePointer<Int>
    ) -> Bool {
        return false
    }

    override func schedule(in aRunLoop: RunLoop, forMode mode: RunLoop.Mode) {
        // URLSessionDataTask runs independently; it has no run-loop source to schedule.
    }

    override func remove(from aRunLoop: RunLoop, forMode mode: RunLoop.Mode) {
        // No run-loop source was scheduled.
    }

    /// Start downloading `url` into the internal buffer.
    override func open() {
        lock.lock()
        guard _status == .notOpen else {
            lock.unlock()
            return
        }
        _status = .open
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        let session = URLSession(configuration: config, delegate: InputStreamNetWorkDelegate(owner: self), delegateQueue: nil)
        let task = session.dataTask(with: url)
        self.session = session
        self.task = task
        lock.unlock()
        task.resume()
    }

    /// Cancel the download and drop the session.
    override func close() {
        lock.lock()
        guard _status != .closed else {
            lock.unlock()
            return
        }
        _status = .closed
        isFinished = true
        isSuspended = false
        let task = self.task
        let session = self.session
        self.task = nil
        self.session = nil
        lock.unlock()

        task?.cancel()
        session?.invalidateAndCancel()
        semaphore.signal()
    }

    override var hasBytesAvailable: Bool {
        lock.lock()
        defer { lock.unlock() }
        return (buffer.count - readOffset) > 0 || (!isFinished && _status == .open)
    }

    /// Copy up to `len` downloaded bytes into `buf`, waiting for more when the buffer is empty.
    ///
    /// - Returns: Bytes copied, `0` at end of file, `-1` when the transfer failed.
    override func read(_ buf: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        guard len > 0 else { return 0 }
        lock.lock()
        let initialStatus = _status
        lock.unlock()
        if initialStatus == .atEnd || initialStatus == .closed { return 0 }
        if initialStatus != .open { return -1 }

        while true {
            lock.lock()
            let available = buffer.count - readOffset
            if available > 0 {
                let toRead = min(len, available)
                buffer.withUnsafeBytes { src in
                    let ptr = src.bindMemory(to: UInt8.self)
                    memcpy(buf, ptr.baseAddress! + readOffset, toRead)
                }
                readOffset += toRead
                if readOffset >= buffer.count {
                    buffer.removeAll(keepingCapacity: true)
                    readOffset = 0
                }
                var taskToResume: URLSessionDataTask?
                if isSuspended && (buffer.count - readOffset) < resumeThreshold {
                    isSuspended = false
                    taskToResume = task
                }
                lock.unlock()
                taskToResume?.resume()
                return toRead
            }

            if isFinished {
                let error = _streamError
                lock.unlock()
                return error == nil ? 0 : -1
            }
            lock.unlock()
            semaphore.wait()
        }
    }

    override var streamStatus: Stream.Status {
        lock.lock()
        defer { lock.unlock() }
        return _status
    }

    override var streamError: any Error? {
        lock.lock()
        defer { lock.unlock() }
        return _streamError
    }

    // MARK: - Delegate Callbacks (internal)
    /// Append a downloaded chunk and wake a blocked reader.
    fileprivate func didReceiveData(_ data: Data) {
        lock.lock()
        guard !isFinished && _status == .open else {
            lock.unlock()
            return
        }
        buffer.append(data)
        var taskToSuspend: URLSessionDataTask?
        if !isSuspended && (buffer.count - readOffset) >= maxBufferSize {
            isSuspended = true
            taskToSuspend = task
        }
        lock.unlock()
        taskToSuspend?.suspend()
        semaphore.signal()
    }

    /// Mark the stream finished and record the transfer error, if any.
    fileprivate func didFinish(error: any Error?) {
        lock.lock()
        guard _status != .closed else {
            lock.unlock()
            return
        }
        _streamError = error
        isFinished = true
        _status = error == nil ? .atEnd : .error
        lock.unlock()
        semaphore.signal()
    }
}

// MARK: - URLSessionDataDelegate
private final class InputStreamNetWorkDelegate: NSObject, URLSessionDataDelegate, @unchecked Sendable {
    weak var owner: NetworkInputStream?

    init(owner: NetworkInputStream) { self.owner = owner }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        owner?.didReceiveData(data)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: any Error?) {
        owner?.didFinish(error: error)
    }
}

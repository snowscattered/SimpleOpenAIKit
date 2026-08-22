//
//  NetworkInputStream.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/10/26.
//

import Foundation

package final class NetworkInputStream: InputStream {
    private let url: URL
    private var task: URLSessionDataTask?
    private var session: URLSession?

    private var buffer = Data(capacity: 64 * 1024)
    private let maxBufferSize = 64 * 1024
    private var readOffset = 0
    private var isFinished = false

    private let lock = NSLock()
    private let semaphore = DispatchSemaphore(value: 0)

    override init(url: URL) {
        self.url = url
        super.init(data: Data())
    }

    package override func open() {
        let delegate = InputStreamNetWorkDelegate(owner: self)
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        session = URLSession(configuration: config, delegate: delegate, delegateQueue: nil)
        task = session?.dataTask(with: url)
        task?.resume()
    }

    package override func close() {
        task?.cancel()
        session?.invalidateAndCancel()
        task = nil
        session = nil
    }

    package override var hasBytesAvailable: Bool {
        lock.lock()
        defer { lock.unlock() }
        return (buffer.count - readOffset) > 0 || (!isFinished && streamError == nil)
    }

    package override func read(_ buf: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
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
                lock.unlock()
                return toRead
            }

            if isFinished {
                lock.unlock()
                return streamError != nil ? -1 : 0
            }
            lock.unlock()
            semaphore.wait()
        }
    }

    package override var streamStatus: Stream.Status {
        lock.lock()
        defer { lock.unlock() }
        if streamError != nil { return .error }
        if isFinished && (buffer.count - readOffset) == 0 { return .closed }
        return .open
    }

    package override var streamError: Error? {
        lock.lock()
        defer { lock.unlock() }
        return _streamError
    }
    private var _streamError: Error?

    // MARK: - Delegate Callbacks (internal)
    fileprivate func didReceiveData(_ data: Data) {
        lock.lock()
        if buffer.count < maxBufferSize {
            buffer.append(data)
        }
        lock.unlock()
        semaphore.signal()
    }

    fileprivate func didFinish(error: Error?) {
        lock.lock()
        _streamError = error
        isFinished = true
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

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        owner?.didFinish(error: error)
    }
}

//
//  URLSessionExtention.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/29/26.
//

import Foundation

/// Scratch space for a blocking call whose result arrives on a URLSession callback queue.
private final class ResponseContainer: @unchecked Sendable {
    var data: Data = Data()
    var bytes: URLSession.AsyncBytes?
    var response: URLResponse?
    var error: any Error?
    var errorData: Data = Data()
}

extension URLSession {
    /// Stream the body as buffers of up to `chunk` bytes, flushing early on every `\n` so SSE lines stay whole.
    ///
    /// A non-2xx status is drained first and thrown as `NetworkError.statusError` with the error body attached.
    /// - Returns: A stream that finishes with the transfer; cancelling it stops the download.
    func asyncStreamData(_ request: URLRequest, chunk: Int = 1024) async throws -> AsyncStream<Data> {
        let (bytes, response) = try await URLSession.shared.bytes(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard 200...299 ~= httpResponse.statusCode else {
            var errorData = Data()
            for try await byte in bytes {
                errorData.append(byte)
            }
            throw NetworkError.statusError(data: errorData, request: request, response: httpResponse)
        }
        
        return AsyncStream { continuation in
            let task = Task.detached {
                var buffer = Data(capacity: chunk)
                for try await byte in bytes {
                    if Task.isCancelled { break }
                    buffer.append(byte)
                    if buffer.count >= chunk || byte == 0x0A {  // "\n" in SSE
                        continuation.yield(buffer)
                        buffer.removeAll(keepingCapacity: true)
                    }
                }
                if !buffer.isEmpty {
                    continuation.yield(buffer)
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in task.cancel() }
        }
    }
    /// Blocking counterpart of `asyncStreamData`: parks on a semaphore until headers arrive, then streams.
    func syncStreamData(_ request: URLRequest, chunk: Int = 1024) throws -> SyncStream<Data> {
        let container = ResponseContainer()
        let semaphore = DispatchSemaphore(value: 0)
        let networkTask = Task.detached(priority: Task.currentPriority) {
            do {
                let (bytes, response) = try await URLSession.shared.bytes(for: request)
                container.bytes = bytes
                container.response = response
            } catch {
                container.error = error
            }
            semaphore.signal()
        }
        let waitResult = semaphore.wait(timeout: .now() + .seconds(Int(request.timeoutInterval) + 1))
        if waitResult == .timedOut {
            networkTask.cancel()
            throw URLError(.timedOut)
        }
        if let error = container.error { throw error }
        
        guard let bytes = container.bytes,
              let response = container.response,
              let httpResponse = response as? HTTPURLResponse
        else { throw URLError(.badServerResponse) }
        guard 200...299 ~= httpResponse.statusCode else {
            let errorSemaphore = DispatchSemaphore(value: 0)
            Task.detached(priority: Task.currentPriority) {
                do {
                    for try await byte in bytes {
                        container.errorData.append(byte)
                    }
                } catch { container.error = error }
                errorSemaphore.signal()
            }
            errorSemaphore.wait()
            if let error = container.error { throw error }
            throw NetworkError.statusError(data: container.errorData, request: request, response: httpResponse)
        }
        
        return SyncStream { continuation in
            let task = Task.detached(priority: Task.currentPriority) {
                var buffer = Data(capacity: chunk)
                for try await byte in bytes {
                    if Task.isCancelled { break }
                    buffer.append(byte)
                    if buffer.count >= chunk || byte == 0x0A {  // "\n" in SSE
                        continuation.yield(buffer)
                        buffer.removeAll(keepingCapacity: true)
                    }
                }
                if !buffer.isEmpty {
                    continuation.yield(buffer)
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in task.cancel() }
        }
    }
    // MARK: - StreamSSE
    /// `asyncStreamData` with each chunk fed through `parser` to yield events instead of bytes.
    func asyncSSE(_ request: URLRequest, parser: any CustomParser = EventParser()) async throws -> AsyncStream<Event> {
        return try await self.asyncStreamData(request).conversion { chunk in
            let events = parser.parse(chunk)
            if events.isEmpty { return .skip }
            return .yieldMore(events)
        }
    }
    /// `syncStreamData` with each chunk fed through `parser` to yield events instead of bytes.
    func syncSSE(_ request: URLRequest, parser: any CustomParser = EventParser()) throws -> SyncStream<Event> {
        return try self.syncStreamData(request).conversion { chunk in
            let events = parser.parse(chunk)
            if events.isEmpty { return .skip }
            return .yieldMore(events)
        }
    }
    // MARK: - Data
    /// Load the whole body, throwing `NetworkError.statusError` on a non-2xx status.
    func asyncData(_ request: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        guard 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.statusError(data: data, request: request, response: httpResponse)
        }
        return data
    }
    /// Blocking counterpart of `asyncData`; the wait is `request.timeoutInterval` plus one second.
    func syncData(_ request: URLRequest) throws -> Data {
        let semaphore = DispatchSemaphore(value: 0)
        let container = ResponseContainer()
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            container.data.append(data ?? Data())
            container.error = error
            container.response = response
            semaphore.signal()
        }
        task.resume()
        let waitResult = semaphore.wait(timeout: .now() + .seconds(Int(request.timeoutInterval) + 1))
        if waitResult == .timedOut {
            task.cancel()
            throw URLError(.timedOut)
        }
        if let error = container.error { throw error }
        guard let response = container.response else { throw URLError(.badServerResponse) }
        guard let httpResponse = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        guard 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.statusError(data: container.data, request: request, response: httpResponse)
        }
        return container.data
    }
}

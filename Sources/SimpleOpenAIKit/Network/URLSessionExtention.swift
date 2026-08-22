//
//  URLSessionExtention.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/29/26.
//

import Foundation

private final class ResponseContainer: @unchecked Sendable {
    var data: Data = Data()
    var bytes: URLSession.AsyncBytes?
    var response: URLResponse?
    var error: Error?
    var errorData: Data = Data()
}

extension URLSession {
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
            throw NetworkError.statusError(statusCode: httpResponse.statusCode, data: errorData)
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
            throw NetworkError.statusError(statusCode: httpResponse.statusCode, data: container.errorData)
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
    func asyncSSE(_ request: URLRequest) async throws -> AsyncStream<Event> {
        let parser = EventParser()
        return try await self.asyncStreamData(request).conversion { chunk in
            let events = parser.parse(chunk)
            if events.isEmpty { return .skip }
            return .yieldMore(events)
        }
    }
    func syncSSE(_ request: URLRequest) throws -> SyncStream<Event> {
        let parser = EventParser()
        return try self.syncStreamData(request).conversion { chunk in
            let events = parser.parse(chunk)
            if events.isEmpty { return .skip }
            return .yieldMore(events)
        }
    }
    // MARK: - Data
    func asyncData(_ request: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        guard 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.statusError(statusCode: httpResponse.statusCode, data: data)
        }
        return data
    }
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
            throw NetworkError.statusError(statusCode: httpResponse.statusCode, data: container.data)
        }
        return container.data
    }
}

//
//  ResponsesAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public extension OpenAIAsyncAPIResource.ResponsesAsyncResource {
    func create(
        parameters: ResponseCreateParameters,
        requestOptions: RequestOptions? = nil
    ) async throws -> ResponseCreateResult {
        let url = try client.getServerUrl(path: "/responses")
        var nostreamingParameters = parameters
        nostreamingParameters.stream = false
        return try await OpenAISession.shared.AsyncResponse(
            url,
            payload: nostreamingParameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post
        )
    }

    func stream(
        parameters: ResponseCreateParameters,
        requestOptions: RequestOptions? = nil
    ) async throws -> AsyncThrowingStream<ResponseStreamResult, Error> {
        let url = try client.getServerUrl(path: "/responses")
        var streamingParameters = parameters
        streamingParameters.stream = true
        return try await OpenAISession.shared.AsyncStreamResponse(
            url,
            payload: streamingParameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post
        )
    }
    // MARK: Retrieve
    func retrieve(
        parameters: ResponseRetrieveParameters,
        requestOptions: RequestOptions? = nil
    ) async throws -> ResponseCreateResult {
        let url = try client.getServerUrl(path: "/responses/\(parameters.response_id)")
        return try await OpenAISession.shared.AsyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post
        )
    }
    func retrieveStream(
        parameters: ResponseRetrieveParameters,
        requestOptions: RequestOptions? = nil
    ) async throws -> AsyncThrowingStream<ResponseStreamResult, Error> {
        let url = try client.getServerUrl(path: "/responses/\(parameters.response_id)")
        var streamingParameters = parameters
        streamingParameters.stream = true
        return try await OpenAISession.shared.AsyncStreamResponse(
            url,
            payload: streamingParameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post
        )
    }
    // MARK: Cancel
    func cancel(
        response_id: String,
        requestOptions: RequestOptions? = nil
    ) async throws -> ResponseCreateResult {
        let url = try client.getServerUrl(path: "/responses/\(response_id)/cancel")
        return try await OpenAISession.shared.AsyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            client: self.client,
            method: .post
        )
    }
    // MARK: Delete
    func delete(
        response_id: String,
        requestOptions: RequestOptions? = nil
    ) async throws -> ResponseCreateResult {
        let url = try client.getServerUrl(path: "/responses/\(response_id)/delete")
        return try await OpenAISession.shared.AsyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            client: self.client,
            method: .post
        )
    }
    // MARK: compact
    func compact(
        parameters: ResponseCompactParameters?,
        requestOptions: RequestOptions? = nil
    ) async throws -> ResponseCompactResult {
        let url = try client.getServerUrl(path: "/responses/compact")
        return try await OpenAISession.shared.AsyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post
        )
    }
    // MARK: WS-Connection
    func conntent(
        requestOptions: RequestOptions? = nil,
        completion: @escaping @Sendable (AsyncResponseConnection) async throws -> Void
    ) async throws -> Void {
        let url = try client.getWSServerUrl(path: "/responses")
        let ws = try OpenAISession.shared.WebSocket(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            client: self.client,
            method: .get
        )
        let (stream, continuation) = AsyncStream<ResponseStreamResult>.makeStream()
        
        ResponseEventAsyncReceiver(socket: ws, continuation: continuation)
        ws.resume()
        defer {
            ws.cancel(with: .normalClosure, reason: nil)
            continuation.finish()
        }
        try await completion(AsyncResponseConnection(ws: ws, stream: stream))
    }
}

private final class ResponseEventAsyncReceiver: @unchecked Sendable {
    private let ws: URLSessionWebSocketTask
    private let continuation: AsyncStream<ResponseStreamResult>.Continuation
    
    @discardableResult
    init(socket: URLSessionWebSocketTask, continuation: AsyncStream<ResponseStreamResult>.Continuation) {
        self.ws = socket
        self.continuation = continuation
        receiveNext()
    }
    private func receiveNext() {
        ws.receive { [self] result in
            switch result {
            case .success(let message):
                let data: Data
                switch message {
                case .string(let text): data = Data(text.utf8)
                case .data(let receivedData): data = receivedData
                @unknown default: return
                }
                let event = try? JSONCodable.decodeData(ResponseStreamResult.self, from: data)
                self.continuation.yield(event ?? ResponseStreamResult.unkowned(.init(type: "unknown")))
                self.receiveNext()
            case .failure(_): break
            }
        }
    }
}
public class AsyncResponseConnection: AsyncSequence, @unchecked Sendable {
    private let ws: URLSessionWebSocketTask
    private let stream: AsyncStream<ResponseStreamResult>
    private var iterator: AsyncStream<ResponseStreamResult>.AsyncIterator
    
    fileprivate init(ws: URLSessionWebSocketTask, stream: AsyncStream<ResponseStreamResult>) {
        self.ws = ws
        self.stream = stream
        self.iterator = stream.makeAsyncIterator()
    }
    public func makeAsyncIterator() -> AsyncStream<ResponseStreamResult>.AsyncIterator {
        return stream.makeAsyncIterator()
    }
    public func send(event: ResponseClientEventParameters) async throws {
        try await ws.send(.string(String(decoding: JSONCodable.encoder.encode(event), as: UTF8.self)))
    }
    public func revc() async -> ResponseStreamResult? {
        return await self.iterator.next()
    }
}

//
//  ResponsesSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public extension OpenAISyncAPIResource.ResponsesSyncResource {
    func create(
        parameters: ResponseCreateParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> ResponseCreateResult {
        let url = try client.getServerUrl(path: "/responses")
        var nostreamingParameters = parameters
        nostreamingParameters.stream = false
        return try OpenAISession.shared.SyncResponse(
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
    ) throws -> SyncThrowingStream<ResponseStreamResult, Error> {
        let url = try client.getServerUrl(path: "/responses")
        var streamingParameters = parameters
        streamingParameters.stream = true
        return try OpenAISession.shared.SyncStreamResponse(
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
    ) throws -> ResponseCreateResult {
        let url = try client.getServerUrl(path: "/responses/\(parameters.response_id)")
        return try OpenAISession.shared.SyncResponse(
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
    ) throws -> SyncThrowingStream<ResponseStreamResult, Error> {
        let url = try client.getServerUrl(path: "/responses/\(parameters.response_id)")
        var streamingParameters = parameters
        streamingParameters.stream = true
        return try OpenAISession.shared.SyncStreamResponse(
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
    ) throws -> ResponseCreateResult {
        let url = try client.getServerUrl(path: "/responses/\(response_id)/cancel")
        return try OpenAISession.shared.SyncResponse(
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
    ) throws -> ResponseCreateResult {
        let url = try client.getServerUrl(path: "/responses/\(response_id)/delete")
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            client: self.client,
            method: .post
        )
    }
    // MARK: compact
    func compact(
        parameters: ResponseCompactParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> ResponseCompactResult {
        let url = try client.getServerUrl(path: "/responses/compact")
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post
        )
    }
    // MARK: WS-Connection
    func connect(
        requestOptions: RequestOptions? = nil,
        completion: @escaping (SyncResponseConnection) throws -> Void
    ) throws {
        let url = try client.getWSServerUrl(path: "/responses")
        let ws = try OpenAISession.shared.WebSocket(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            client: self.client,
            method: .get
        )
        let (stream, continuation) = SyncStream<ResponseStreamResult>.makeStream()

        ResponseEventSyncReceiver(socket: ws, continuation: continuation)
        ws.resume()
        defer {
            ws.cancel(with: .normalClosure, reason: nil)
            continuation.finish()
        }
        try completion(SyncResponseConnection(ws: ws, stream: stream))
    }
}

private final class ResponseEventSyncReceiver: @unchecked Sendable {
    private let ws: URLSessionWebSocketTask
    private let continuation: SyncStream<ResponseStreamResult>.Continuation

    @discardableResult
    init(socket: URLSessionWebSocketTask, continuation: SyncStream<ResponseStreamResult>.Continuation) {
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
                let event = try? decodeData(ResponseStreamResult.self, from: data)
                continuation.yield(event ?? ResponseStreamResult.unkowned(.init(type: "unknown")))
                self.receiveNext()
            case .failure(_): break
            }
        }
    }
}

public class SyncResponseConnection: Sequence, @unchecked Sendable {
    private let ws: URLSessionWebSocketTask
    private let stream: SyncStream<ResponseStreamResult>
    private var iterator: SyncStream<ResponseStreamResult>.Iterator

    fileprivate init(ws: URLSessionWebSocketTask, stream: SyncStream<ResponseStreamResult>) {
        self.ws = ws
        self.stream = stream
        self.iterator = stream.makeIterator()
    }
    public func makeIterator() -> SyncStream<ResponseStreamResult>.Iterator {
        return stream.makeIterator()
    }
    public func send(event: ResponseClientEventParameters) throws {
        try ws.send(.string(String(decoding: JSONEncoder().encode(event), as: UTF8.self))) { _ in }
    }
    public func recv() -> ResponseStreamResult? {
        return self.iterator.next()
    }
}

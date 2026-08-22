//
//  RealtimeAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/9/26.
//

import Foundation

private final class RealtimeEventAsyncReceiver: @unchecked Sendable {
    private let ws: URLSessionWebSocketTask
    private let continuation: AsyncStream<RealtimeEventResult>.Continuation
    
    @discardableResult
    init(socket: URLSessionWebSocketTask, continuation: AsyncStream<RealtimeEventResult>.Continuation) {
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
                let event = try? JSONCodable.decodeData(RealtimeEventResult.self, from: data)
                self.continuation.yield(event ?? RealtimeEventResult.unkowned(.init(type: "unknown")))
                self.receiveNext()
            case .failure(_): break
            }
        }
    }
}

public extension OpenAIAsyncAPIResource.RealtimeAsyncResource {
    func conntent(
        model: String,
        call_id: String? = nil,
        requestOptions: RequestOptions? = nil,
        completion: @escaping @Sendable (AsyncRealtimeConnection) async throws -> Void
    ) async throws -> Void {
        let url = try client.getWSServerUrl(path: "/realtime")
        var requestOptions = requestOptions ?? RequestOptions()
        if let call_id {
            requestOptions.extra_query = requestOptions.extra_query | ["call_id": .string(call_id)]
        }
        requestOptions.extra_query = requestOptions.extra_query | ["model": .string(model)]
        let ws = try OpenAISession.shared.WebSocket(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            client: self.client,
            method: .get
        )
        let (stream, continuation) = AsyncStream<RealtimeEventResult>.makeStream()
        
        RealtimeEventAsyncReceiver(socket: ws, continuation: continuation)
        ws.resume()
        defer {
            ws.cancel(with: .normalClosure, reason: nil)
            continuation.finish()
        }
        try await completion(AsyncRealtimeConnection(ws: ws, stream: stream))
    }
}

public class AsyncRealtimeResource {
    let connection: AsyncRealtimeConnection
    init(_ connection: AsyncRealtimeConnection) {
        self.connection = connection
    }
}
public class AsyncRealtimeSessionResource: AsyncRealtimeResource {
    func update(event_id: String? = nil, session: RealtimeSession) async throws {
        try await self.connection.send(event: .session_update(.init(event_id: event_id, session: session)))
    }
}
public class AsyncRealtimeResponseResource: AsyncRealtimeResource {
    func create(event_id: String? = nil, response: RealtimeResponse) async throws {
        try await self.connection.send(event: .response_create(.init(event_id: event_id, response: response)))
    }
    func cancel(event_id: String? = nil, response_id: String? = nil) async throws {
        try await self.connection.send(event: .response_cancel(.init(event_id: event_id, response_id: response_id)))
    }
}
public class AsyncRealtimeConversationItemResource: AsyncRealtimeResource {
    func create(event_id: String? = nil, item: RealtimeConversationItem) async throws {
        try await self.connection.send(event: .conversation_create(.init(event_id: event_id, item: item)))
    }
    func delete(event_id: String? = nil, item_id: String) async throws {
        try await self.connection.send(event: .conversation_delete(.init(event_id: event_id, item_id: item_id)))
    }
}
public class AsyncRealtimeConversationResource: AsyncRealtimeResource {
    lazy var item = AsyncRealtimeConversationItemResource(self.connection)
}
public class AsyncRealtimeInputAudioBufferResource: AsyncRealtimeResource {
    func append(event_id: String? = nil, audio: String) async throws {
        try await self.connection.send(event: .input_audio_buffer_append(.init(event_id: event_id, audio: audio)))
    }
    func commit(event_id: String? = nil) async throws {
        try await self.connection.send(event: .input_audio_buffer_commit(.init(event_id: event_id)))
    }
    func clear(event_id: String? = nil) async throws {
        try await self.connection.send(event: .input_audio_buffer_clear(.init(event_id: event_id)))
    }
}
public class AsyncRealtimeOutputAudioBufferResource: AsyncRealtimeResource {
    func clear(event_id: String? = nil) async throws {
        try await self.connection.send(event: .output_audio_buffer_clear(.init(event_id: event_id)))
    }
}

public class AsyncRealtimeConnection: AsyncSequence, @unchecked Sendable {
    private let ws: URLSessionWebSocketTask
    private let stream: AsyncStream<RealtimeEventResult>
    private var iterator: AsyncStream<RealtimeEventResult>.AsyncIterator
    
    public lazy var session: AsyncRealtimeSessionResource = AsyncRealtimeSessionResource(self)
    public lazy var response: AsyncRealtimeResponseResource = AsyncRealtimeResponseResource(self)
    public lazy var conversation: AsyncRealtimeConversationResource = AsyncRealtimeConversationResource(self)
    public lazy var input_audio_buffer: AsyncRealtimeInputAudioBufferResource = AsyncRealtimeInputAudioBufferResource(self)
    public lazy var ouput_audio_buffer: AsyncRealtimeOutputAudioBufferResource = AsyncRealtimeOutputAudioBufferResource(self)
    
    fileprivate init(ws: URLSessionWebSocketTask, stream: AsyncStream<RealtimeEventResult>) {
        self.ws = ws
        self.stream = stream
        self.iterator = stream.makeAsyncIterator()
    }
    public func makeAsyncIterator() -> AsyncStream<RealtimeEventResult>.AsyncIterator {
        return stream.makeAsyncIterator()
    }
    public func send(event: RealtimeEventParameters) async throws {
        try await ws.send(.string(String(decoding: JSONCodable.encoder.encode(event), as: UTF8.self)))
    }
    public func revc() async -> RealtimeEventResult? {
        return await self.iterator.next()
    }
}

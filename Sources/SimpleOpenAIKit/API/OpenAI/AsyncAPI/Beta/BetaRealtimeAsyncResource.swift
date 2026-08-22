//
//  BetaRealtimeAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation

private final class BetaRealtimeEventAsyncReceiver: @unchecked Sendable {
    private let ws: URLSessionWebSocketTask
    private let continuation: AsyncStream<BetaRealtimeEventResult>.Continuation
    
    @discardableResult
    init(socket: URLSessionWebSocketTask, continuation: AsyncStream<BetaRealtimeEventResult>.Continuation) {
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
                let event = try? JSONCodable.decodeData(BetaRealtimeEventResult.self, from: data)
                self.continuation.yield(event ?? BetaRealtimeEventResult.unkowned(.init(type: "unknown")))
                self.receiveNext()
            case .failure(_): break
            }
        }
    }
}

public extension OpenAIAsyncAPIResource.BetaRealtimeAsyncResource {
    func conntent(
        model: String,
        call_id: String? = nil,
        requestOptions: RequestOptions? = nil,
        completion: @escaping @Sendable (BetaAsyncRealtimeConnection) async throws -> Void
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
        let (stream, continuation) = AsyncStream<BetaRealtimeEventResult>.makeStream()
        
        ws.resume()
        BetaRealtimeEventAsyncReceiver(socket: ws, continuation: continuation)
        defer {
            ws.cancel(with: .normalClosure, reason: nil)
            continuation.finish()
        }
        try await completion(BetaAsyncRealtimeConnection(ws: ws, stream: stream))
    }
}

public class BetaAsyncRealtimeResource {
    let connection: BetaAsyncRealtimeConnection
    init(_ connection: BetaAsyncRealtimeConnection) {
        self.connection = connection
    }
}
public class BetaAsyncRealtimeSessionResource: BetaAsyncRealtimeResource {
    func update(event_id: String? = nil, session: BetaRealtimeSession) async throws {
        try await self.connection.send(event: .session_update(.init(event_id: event_id, session: session)))
    }
}
public class BetaAsyncRealtimeResponseResource: BetaAsyncRealtimeResource {
    func create(event_id: String? = nil, response: BetaRealtimeResponse) async throws {
        try await self.connection.send(event: .response_create(.init(event_id: event_id, response: response)))
    }
    func cancel(event_id: String? = nil, response_id: String? = nil) async throws {
        try await self.connection.send(event: .response_cancel(.init(event_id: event_id, response_id: response_id)))
    }
}
public class BetaAsyncRealtimeConversationItemResource: BetaAsyncRealtimeResource {
    func create(event_id: String? = nil, item: BetaRealtimeConversationItem) async throws {
        try await self.connection.send(event: .conversation_create(.init(event_id: event_id, item: item)))
    }
    func delete(event_id: String? = nil, item_id: String) async throws {
        try await self.connection.send(event: .conversation_delete(.init(event_id: event_id, item_id: item_id)))
    }
}
public class BetaAsyncRealtimeConversationResource: BetaAsyncRealtimeResource {
    lazy var item = BetaAsyncRealtimeConversationItemResource(self.connection)
}
public class BetaAsyncRealtimeInputAudioBufferResource: BetaAsyncRealtimeResource {
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
public class BetaAsyncRealtimeOutputAudioBufferResource: BetaAsyncRealtimeResource {
    func clear(event_id: String? = nil) async throws {
        try await self.connection.send(event: .output_audio_buffer_clear(.init(event_id: event_id)))
    }
}

public class BetaAsyncRealtimeConnection: AsyncSequence, @unchecked Sendable {
    private let ws: URLSessionWebSocketTask
    private let stream: AsyncStream<BetaRealtimeEventResult>
    private var iterator: AsyncStream<BetaRealtimeEventResult>.AsyncIterator
    
    public lazy var session: BetaAsyncRealtimeSessionResource = BetaAsyncRealtimeSessionResource(self)
    public lazy var response: BetaAsyncRealtimeResponseResource = BetaAsyncRealtimeResponseResource(self)
    public lazy var conversation: BetaAsyncRealtimeConversationResource = BetaAsyncRealtimeConversationResource(self)
    public lazy var input_audio_buffer: BetaAsyncRealtimeInputAudioBufferResource = BetaAsyncRealtimeInputAudioBufferResource(self)
    public lazy var ouput_audio_buffer: BetaAsyncRealtimeOutputAudioBufferResource = BetaAsyncRealtimeOutputAudioBufferResource(self)
    
    fileprivate init(ws: URLSessionWebSocketTask, stream: AsyncStream<BetaRealtimeEventResult>) {
        self.ws = ws
        self.stream = stream
        self.iterator = stream.makeAsyncIterator()
    }
    public func makeAsyncIterator() -> AsyncStream<BetaRealtimeEventResult>.AsyncIterator {
        return stream.makeAsyncIterator()
    }
    public func send(event: BetaRealtimeEventParameters) async throws {
        try await ws.send(.string(String(decoding: JSONCodable.encoder.encode(event), as: UTF8.self)))
    }
    public func revc() async -> BetaRealtimeEventResult? {
        return await self.iterator.next()
    }
}

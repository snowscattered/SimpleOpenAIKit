//
//  BetaRealtimeSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation

private final class BetaRealtimeEventSyncReceiver: @unchecked Sendable {
    private let ws: URLSessionWebSocketTask
    private let continuation: SyncStream<BetaRealtimeEventResult>.Continuation
    
    @discardableResult
    init(socket: URLSessionWebSocketTask, continuation: SyncStream<BetaRealtimeEventResult>.Continuation) {
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
                continuation.yield(event ?? BetaRealtimeEventResult.unkowned(.init(type: "unknown")))
                self.receiveNext()
            case .failure(_): break
            }
        }
    }
}

public extension OpenAISyncAPIResource.BetaRealtimeSyncResource {
    func connect(
        model: String,
        call_id: String? = nil,
        requestOptions: RequestOptions? = nil,
        completion: @escaping (BetaSyncRealtimeConnection) throws -> Void
    ) throws {
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
        let (stream, continuation) = SyncStream<BetaRealtimeEventResult>.makeStream()
        BetaRealtimeEventSyncReceiver(socket: ws, continuation: continuation)
        ws.resume()
        defer {
            ws.cancel(with: .normalClosure, reason: nil)
            continuation.finish()
        }
        try completion(BetaSyncRealtimeConnection(ws: ws, stream: stream))
    }
}

public class BetaSyncRealtimeResource {
    let connection: BetaSyncRealtimeConnection
    init(_ connection: BetaSyncRealtimeConnection) {
        self.connection = connection
    }
}
public class BetaSyncRealtimeSessionResource: BetaSyncRealtimeResource {
    func update(event_id: String? = nil, session: BetaRealtimeSession) throws {
        try self.connection.send(event: .session_update(.init(event_id: event_id, session: session)))
    }
}
public class BetaSyncRealtimeResponseResource: BetaSyncRealtimeResource {
    func create(event_id: String? = nil, response: BetaRealtimeResponse) throws {
        try self.connection.send(event: .response_create(.init(event_id: event_id, response: response)))
    }
    func cancel(event_id: String? = nil, response_id: String? = nil) throws {
        try self.connection.send(event: .response_cancel(.init(event_id: event_id, response_id: response_id)))
    }
}
public class BetaSyncRealtimeConversationItemResource: BetaSyncRealtimeResource {
    func create(event_id: String? = nil, item: BetaRealtimeConversationItem) throws {
        try self.connection.send(event: .conversation_create(.init(event_id: event_id, item: item)))
    }
    func delete(event_id: String? = nil, item_id: String) throws {
        try self.connection.send(event: .conversation_delete(.init(event_id: event_id, item_id: item_id)))
    }
}
public class BetaSyncRealtimeConversationResource: BetaSyncRealtimeResource {
    lazy var item = BetaSyncRealtimeConversationItemResource(self.connection)
}
public class BetaSyncRealtimeInputAudioBufferResource: BetaSyncRealtimeResource {
    func append(event_id: String? = nil, audio: String) throws {
        try self.connection.send(event: .input_audio_buffer_append(.init(event_id: event_id, audio: audio)))
    }
    func commit(event_id: String? = nil) throws {
        try self.connection.send(event: .input_audio_buffer_commit(.init(event_id: event_id)))
    }
    func clear(event_id: String? = nil) throws {
        try self.connection.send(event: .input_audio_buffer_clear(.init(event_id: event_id)))
    }
}
public class BetaSyncRealtimeOutputAudioBufferResource: BetaSyncRealtimeResource {
    func clear(event_id: String? = nil) throws {
        try self.connection.send(event: .output_audio_buffer_clear(.init(event_id: event_id)))
    }
}

public class BetaSyncRealtimeConnection: Sequence, @unchecked Sendable {
    private let ws: URLSessionWebSocketTask
    private let stream: SyncStream<BetaRealtimeEventResult>
    private var iterator: SyncStream<BetaRealtimeEventResult>.Iterator

    public lazy var session: BetaSyncRealtimeSessionResource = BetaSyncRealtimeSessionResource(self)
    public lazy var response: BetaSyncRealtimeResponseResource = BetaSyncRealtimeResponseResource(self)
    public lazy var conversation: BetaSyncRealtimeConversationResource = BetaSyncRealtimeConversationResource(self)
    public lazy var input_audio_buffer: BetaSyncRealtimeInputAudioBufferResource = BetaSyncRealtimeInputAudioBufferResource(self)
    public lazy var output_audio_buffer: BetaSyncRealtimeOutputAudioBufferResource = BetaSyncRealtimeOutputAudioBufferResource(self)

    fileprivate init(ws: URLSessionWebSocketTask, stream: SyncStream<BetaRealtimeEventResult>) {
        self.ws = ws
        self.stream = stream
        self.iterator = stream.makeIterator()
    }
    public func makeIterator() -> SyncStream<BetaRealtimeEventResult>.Iterator {
        return stream.makeIterator()
    }
    public func send(event: BetaRealtimeEventParameters) throws {
        try ws.send(.string(String(decoding: JSONCodable.encoder.encode(event), as: UTF8.self))) { _ in }
    }

    public func recv() -> BetaRealtimeEventResult? {
        return self.iterator.next()
    }
}

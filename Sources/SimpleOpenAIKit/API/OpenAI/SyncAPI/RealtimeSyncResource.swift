//
//  RealtimeSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/11/26.
//

import Foundation

private final class RealtimeEventSyncReceiver: @unchecked Sendable {
    private let ws: URLSessionWebSocketTask
    private let continuation: SyncStream<RealtimeEventResult>.Continuation
    
    @discardableResult
    init(socket: URLSessionWebSocketTask, continuation: SyncStream<RealtimeEventResult>.Continuation) {
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
                continuation.yield(event ?? RealtimeEventResult.unkowned(.init(type: "unknown")))
                self.receiveNext()
            case .failure(_): break
            }
        }
    }
}

public extension OpenAISyncAPIResource.RealtimeSyncResource {
    func connect(
        model: String,
        call_id: String? = nil,
        requestOptions: RequestOptions? = nil,
        completion: @escaping (SyncRealtimeConnection) throws -> Void
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
        let (stream, continuation) = SyncStream<RealtimeEventResult>.makeStream()
        RealtimeEventSyncReceiver(socket: ws, continuation: continuation)
        ws.resume()
        defer {
            ws.cancel(with: .normalClosure, reason: nil)
            continuation.finish()
        }
        try completion(SyncRealtimeConnection(ws: ws, stream: stream))
    }
}

public class SyncRealtimeResource {
    let connection: SyncRealtimeConnection
    init(_ connection: SyncRealtimeConnection) {
        self.connection = connection
    }
}
public class SyncRealtimeSessionResource: SyncRealtimeResource {
    func update(event_id: String? = nil, session: RealtimeSession) throws {
        try self.connection.send(event: .session_update(.init(event_id: event_id, session: session)))
    }
}
public class SyncRealtimeResponseResource: SyncRealtimeResource {
    func create(event_id: String? = nil, response: RealtimeResponse) throws {
        try self.connection.send(event: .response_create(.init(event_id: event_id, response: response)))
    }
    func cancel(event_id: String? = nil, response_id: String? = nil) throws {
        try self.connection.send(event: .response_cancel(.init(event_id: event_id, response_id: response_id)))
    }
}
public class SyncRealtimeConversationItemResource: SyncRealtimeResource {
    func create(event_id: String? = nil, item: RealtimeConversationItem) throws {
        try self.connection.send(event: .conversation_create(.init(event_id: event_id, item: item)))
    }
    func delete(event_id: String? = nil, item_id: String) throws {
        try self.connection.send(event: .conversation_delete(.init(event_id: event_id, item_id: item_id)))
    }
}
public class SyncRealtimeConversationResource: SyncRealtimeResource {
    lazy var item = SyncRealtimeConversationItemResource(self.connection)
}
public class SyncRealtimeInputAudioBufferResource: SyncRealtimeResource {
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
public class SyncRealtimeOutputAudioBufferResource: SyncRealtimeResource {
    func clear(event_id: String? = nil) throws {
        try self.connection.send(event: .output_audio_buffer_clear(.init(event_id: event_id)))
    }
}

public class SyncRealtimeConnection: Sequence, @unchecked Sendable {
    private let ws: URLSessionWebSocketTask
    private let stream: SyncStream<RealtimeEventResult>
    private var iterator: SyncStream<RealtimeEventResult>.Iterator

    public lazy var session: SyncRealtimeSessionResource = SyncRealtimeSessionResource(self)
    public lazy var response: SyncRealtimeResponseResource = SyncRealtimeResponseResource(self)
    public lazy var conversation: SyncRealtimeConversationResource = SyncRealtimeConversationResource(self)
    public lazy var input_audio_buffer: SyncRealtimeInputAudioBufferResource = SyncRealtimeInputAudioBufferResource(self)
    public lazy var output_audio_buffer: SyncRealtimeOutputAudioBufferResource = SyncRealtimeOutputAudioBufferResource(self)

    fileprivate init(ws: URLSessionWebSocketTask, stream: SyncStream<RealtimeEventResult>) {
        self.ws = ws
        self.stream = stream
        self.iterator = stream.makeIterator()
    }
    public func makeIterator() -> SyncStream<RealtimeEventResult>.Iterator {
        return stream.makeIterator()
    }
    public func send(event: RealtimeEventParameters) throws {
        try ws.send(.string(String(decoding: JSONCodable.encoder.encode(event), as: UTF8.self))) { _ in }
    }

    public func recv() -> RealtimeEventResult? {
        return self.iterator.next()
    }
}

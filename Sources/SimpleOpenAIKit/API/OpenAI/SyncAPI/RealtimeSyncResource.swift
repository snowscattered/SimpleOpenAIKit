//
//  RealtimeSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/11/26.
//

import Foundation

/// Decodes every websocket frame into `RealtimeEventResult`; frames it cannot parse arrive as `.unkowned`.
private final class RealtimeEventSyncReceiver: @unchecked Sendable {
    private let ws: URLSessionWebSocketTask
    private let continuation: SyncStream<RealtimeEventResult>.Continuation
    
    @discardableResult
    init(socket: URLSessionWebSocketTask, continuation: SyncStream<RealtimeEventResult>.Continuation) {
        self.ws = socket
        self.continuation = continuation
        receiveNext()
    }
    /// Keep the stream supplied by asking the socket for the next message.
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
                let event = try? decodeNetworkData(RealtimeEventResult.self, from: data)
                continuation.yield(event ?? RealtimeEventResult.unkowned(.init(type: "unknown")))
                self.receiveNext()
            case .failure(_): break
            }
        }
    }
}

public extension OpenAISyncAPIResource.RealtimeSyncResource {
    /// Open a realtime websocket for `model`, run `completion` with the live connection, then close it.
    func connect(
        model: String,
        call_id: String? = nil,
        requestOptions: RequestOptions? = nil,
        completion: @escaping (SyncRealtimeConnection) throws -> Void
    ) throws {
        let url = try clientOption.getWSServerUrl(path: "/realtime")
        var requestOptions = requestOptions ?? RequestOptions()
        if let call_id {
            requestOptions.extra_query = requestOptions.extra_query | ["call_id": .string(call_id)]
        }
        requestOptions.extra_query = requestOptions.extra_query | ["model": .string(model)]
        let ws = try OpenAISession.shared.WebSocket(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
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

/// Base for the sub-resources that share one realtime connection.
public class SyncRealtimeResource {
    let connection: SyncRealtimeConnection
    init(_ connection: SyncRealtimeConnection) {
        self.connection = connection
    }
}
/// Session-level events.
public class SyncRealtimeSessionResource: SyncRealtimeResource {
    /// Replace the live session configuration.
    public func update(event_id: String? = nil, session: RealtimeSession) throws {
        try self.connection.send(event: .session_update(.init(event_id: event_id, session: session)))
    }
}
/// Response lifecycle events.
public class SyncRealtimeResponseResource: SyncRealtimeResource {
    /// Ask the server to produce a response from the current conversation.
    public func create(event_id: String? = nil, response: RealtimeResponse) throws {
        try self.connection.send(event: .response_create(.init(event_id: event_id, response: response)))
    }
    /// Stop the response that is currently generating.
    public func cancel(event_id: String? = nil, response_id: String? = nil) throws {
        try self.connection.send(event: .response_cancel(.init(event_id: event_id, response_id: response_id)))
    }
}
/// Items inside the server-side conversation.
public class SyncRealtimeConversationItemResource: SyncRealtimeResource {
    /// Insert an item into the conversation.
    public func create(event_id: String? = nil, item: RealtimeConversationItem) throws {
        try self.connection.send(event: .conversation_create(.init(event_id: event_id, item: item)))
    }
    /// Remove an item by id.
    public func delete(event_id: String? = nil, item_id: String) throws {
        try self.connection.send(event: .conversation_delete(.init(event_id: event_id, item_id: item_id)))
    }
}
/// Groups `conversation.item`.
public class SyncRealtimeConversationResource: SyncRealtimeResource {
    public lazy var item = SyncRealtimeConversationItemResource(self.connection)
}
/// The microphone audio the client sends up.
public class SyncRealtimeInputAudioBufferResource: SyncRealtimeResource {
    /// Append base64 audio to the input buffer.
    public func append(event_id: String? = nil, audio: String) throws {
        try self.connection.send(event: .input_audio_buffer_append(.init(event_id: event_id, audio: audio)))
    }
    /// Turn the buffered audio into a conversation item.
    public func commit(event_id: String? = nil) throws {
        try self.connection.send(event: .input_audio_buffer_commit(.init(event_id: event_id)))
    }
    /// Drop the buffered input audio.
    public func clear(event_id: String? = nil) throws {
        try self.connection.send(event: .input_audio_buffer_clear(.init(event_id: event_id)))
    }
}
/// The server-generated audio waiting to be played.
public class SyncRealtimeOutputAudioBufferResource: SyncRealtimeResource {
    /// Discard the pending output audio.
    public func clear(event_id: String? = nil) throws {
        try self.connection.send(event: .output_audio_buffer_clear(.init(event_id: event_id)))
    }
}

/// One live realtime websocket: send events, read server events, reach the sub-resources.
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
    /// Iterate server events until the socket closes.
    public func makeIterator() -> SyncStream<RealtimeEventResult>.Iterator {
        return stream.makeIterator()
    }
    /// Encode `event` as JSON text and queue it on the socket.
    public func send(event: RealtimeEventParameters) throws {
        try ws.send(.string(String(decoding: JSONEncoder().encode(event), as: UTF8.self))) { _ in }
    }

    /// Take the next server event, or `nil` once the stream has ended.
    public func recv() -> RealtimeEventResult? {
        return self.iterator.next()
    }
}

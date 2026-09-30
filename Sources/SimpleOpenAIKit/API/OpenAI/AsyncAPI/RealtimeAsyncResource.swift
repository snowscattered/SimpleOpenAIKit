//
//  RealtimeAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/9/26.
//

import Foundation

/// Decodes every websocket frame into `RealtimeEventResult`; frames it cannot parse arrive as `.unkowned`.
private final class RealtimeEventAsyncReceiver: @unchecked Sendable {
    private let ws: URLSessionWebSocketTask
    private let continuation: AsyncStream<RealtimeEventResult>.Continuation
    
    @discardableResult
    init(socket: URLSessionWebSocketTask, continuation: AsyncStream<RealtimeEventResult>.Continuation) {
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
                self.continuation.yield(event ?? RealtimeEventResult.unkowned(.init(type: "unknown")))
                self.receiveNext()
            case .failure(_): break
            }
        }
    }
}

public extension OpenAIAsyncAPIResource.RealtimeAsyncResource {
    /// Open a realtime websocket for `model`, run `completion` with the live connection, then close it.
    func conntent(
        model: String,
        call_id: String? = nil,
        requestOptions: RequestOptions? = nil,
        completion: @escaping @Sendable (AsyncRealtimeConnection) async throws -> Void
    ) async throws -> Void {
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

/// Base for the sub-resources that share one realtime connection.
public class AsyncRealtimeResource {
    let connection: AsyncRealtimeConnection
    init(_ connection: AsyncRealtimeConnection) {
        self.connection = connection
    }
}
/// Session-level events.
public class AsyncRealtimeSessionResource: AsyncRealtimeResource {
    /// Replace the live session configuration.
    public func update(event_id: String? = nil, session: RealtimeSession) async throws {
        try await self.connection.send(event: .session_update(.init(event_id: event_id, session: session)))
    }
}
/// Response lifecycle events.
public class AsyncRealtimeResponseResource: AsyncRealtimeResource {
    /// Ask the server to produce a response from the current conversation.
    public func create(event_id: String? = nil, response: RealtimeResponse) async throws {
        try await self.connection.send(event: .response_create(.init(event_id: event_id, response: response)))
    }
    /// Stop the response that is currently generating.
    public func cancel(event_id: String? = nil, response_id: String? = nil) async throws {
        try await self.connection.send(event: .response_cancel(.init(event_id: event_id, response_id: response_id)))
    }
}
/// Items inside the server-side conversation.
public class AsyncRealtimeConversationItemResource: AsyncRealtimeResource {
    /// Insert an item into the conversation.
    public func create(event_id: String? = nil, item: RealtimeConversationItem) async throws {
        try await self.connection.send(event: .conversation_create(.init(event_id: event_id, item: item)))
    }
    /// Remove an item by id.
    public func delete(event_id: String? = nil, item_id: String) async throws {
        try await self.connection.send(event: .conversation_delete(.init(event_id: event_id, item_id: item_id)))
    }
}
/// Groups `conversation.item`.
public class AsyncRealtimeConversationResource: AsyncRealtimeResource {
    public lazy var item = AsyncRealtimeConversationItemResource(self.connection)
}
/// The microphone audio the client sends up.
public class AsyncRealtimeInputAudioBufferResource: AsyncRealtimeResource {
    /// Append base64 audio to the input buffer.
    public func append(event_id: String? = nil, audio: String) async throws {
        try await self.connection.send(event: .input_audio_buffer_append(.init(event_id: event_id, audio: audio)))
    }
    /// Turn the buffered audio into a conversation item.
    public func commit(event_id: String? = nil) async throws {
        try await self.connection.send(event: .input_audio_buffer_commit(.init(event_id: event_id)))
    }
    /// Drop the buffered input audio.
    public func clear(event_id: String? = nil) async throws {
        try await self.connection.send(event: .input_audio_buffer_clear(.init(event_id: event_id)))
    }
}
/// The server-generated audio waiting to be played.
public class AsyncRealtimeOutputAudioBufferResource: AsyncRealtimeResource {
    /// Discard the pending output audio.
    public func clear(event_id: String? = nil) async throws {
        try await self.connection.send(event: .output_audio_buffer_clear(.init(event_id: event_id)))
    }
}

/// One live realtime websocket: send events, read server events, reach the sub-resources.
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
    /// Iterate server events until the socket closes.
    public func makeAsyncIterator() -> AsyncStream<RealtimeEventResult>.AsyncIterator {
        return stream.makeAsyncIterator()
    }
    /// Encode `event` as JSON text and queue it on the socket.
    public func send(event: RealtimeEventParameters) async throws {
        try await ws.send(.string(String(decoding: JSONEncoder().encode(event), as: UTF8.self)))
    }
    /// Await the next server event, or `nil` once the stream has ended.
    public func recv() async -> RealtimeEventResult? {
        return await self.iterator.next()
    }
}

//
//  BetaRealtimeAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation

/// Decodes every websocket frame into `BetaRealtimeEventResult`; frames it cannot parse arrive as `.unkowned`.
private final class BetaRealtimeEventAsyncReceiver: @unchecked Sendable {
    private let ws: URLSessionWebSocketTask
    private let continuation: AsyncStream<BetaRealtimeEventResult>.Continuation
    
    @discardableResult
    init(socket: URLSessionWebSocketTask, continuation: AsyncStream<BetaRealtimeEventResult>.Continuation) {
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
                let event = try? decodeNetworkData(BetaRealtimeEventResult.self, from: data)
                self.continuation.yield(event ?? BetaRealtimeEventResult.unkowned(.init(type: "unknown")))
                self.receiveNext()
            case .failure(_): break
            }
        }
    }
}

public extension OpenAIAsyncAPIResource.BetaRealtimeAsyncResource {
    /// Open a beta realtime websocket for `model`, run `completion` with the live connection, then close it.
    func conntent(
        model: String,
        call_id: String? = nil,
        requestOptions: RequestOptions? = nil,
        completion: @escaping @Sendable (BetaAsyncRealtimeConnection) async throws -> Void
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

/// Base for the sub-resources that share one beta realtime connection.
public class BetaAsyncRealtimeResource {
    let connection: BetaAsyncRealtimeConnection
    init(_ connection: BetaAsyncRealtimeConnection) {
        self.connection = connection
    }
}
/// Session-level events.
public class BetaAsyncRealtimeSessionResource: BetaAsyncRealtimeResource {
    /// Replace the live session configuration.
    func update(event_id: String? = nil, session: BetaRealtimeSession) async throws {
        try await self.connection.send(event: .session_update(.init(event_id: event_id, session: session)))
    }
}
/// Response lifecycle events.
public class BetaAsyncRealtimeResponseResource: BetaAsyncRealtimeResource {
    /// Ask the server to produce a response from the current conversation.
    func create(event_id: String? = nil, response: BetaRealtimeResponse) async throws {
        try await self.connection.send(event: .response_create(.init(event_id: event_id, response: response)))
    }
    /// Stop the response that is currently generating.
    func cancel(event_id: String? = nil, response_id: String? = nil) async throws {
        try await self.connection.send(event: .response_cancel(.init(event_id: event_id, response_id: response_id)))
    }
}
/// Items inside the server-side conversation.
public class BetaAsyncRealtimeConversationItemResource: BetaAsyncRealtimeResource {
    /// Insert an item into the conversation.
    func create(event_id: String? = nil, item: BetaRealtimeConversationItem) async throws {
        try await self.connection.send(event: .conversation_create(.init(event_id: event_id, item: item)))
    }
    /// Remove an item by id.
    func delete(event_id: String? = nil, item_id: String) async throws {
        try await self.connection.send(event: .conversation_delete(.init(event_id: event_id, item_id: item_id)))
    }
}
/// Groups `conversation.item`.
public class BetaAsyncRealtimeConversationResource: BetaAsyncRealtimeResource {
    lazy var item = BetaAsyncRealtimeConversationItemResource(self.connection)
}
/// The microphone audio the client sends up.
public class BetaAsyncRealtimeInputAudioBufferResource: BetaAsyncRealtimeResource {
    /// Append base64 audio to the input buffer.
    func append(event_id: String? = nil, audio: String) async throws {
        try await self.connection.send(event: .input_audio_buffer_append(.init(event_id: event_id, audio: audio)))
    }
    /// Turn the buffered audio into a conversation item.
    func commit(event_id: String? = nil) async throws {
        try await self.connection.send(event: .input_audio_buffer_commit(.init(event_id: event_id)))
    }
    /// Drop the buffered input audio.
    func clear(event_id: String? = nil) async throws {
        try await self.connection.send(event: .input_audio_buffer_clear(.init(event_id: event_id)))
    }
}
/// The server-generated audio waiting to be played.
public class BetaAsyncRealtimeOutputAudioBufferResource: BetaAsyncRealtimeResource {
    /// Discard the pending output audio.
    func clear(event_id: String? = nil) async throws {
        try await self.connection.send(event: .output_audio_buffer_clear(.init(event_id: event_id)))
    }
}

/// One live beta realtime websocket: send events, read server events, reach the sub-resources.
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
    /// Iterate server events until the socket closes.
    public func makeAsyncIterator() -> AsyncStream<BetaRealtimeEventResult>.AsyncIterator {
        return stream.makeAsyncIterator()
    }
    /// Encode `event` as JSON text and queue it on the socket.
    public func send(event: BetaRealtimeEventParameters) async throws {
        try await ws.send(.string(String(decoding: JSONEncoder().encode(event), as: UTF8.self)))
    }
    /// Await the next server event, or `nil` once the stream has ended.
    public func recv() async -> BetaRealtimeEventResult? {
        return await self.iterator.next()
    }
}

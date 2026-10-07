# API

Endpoint wrappers, grouped by provider and call style. Each call is a thin wrapper over one HTTP
request (or one websocket session): it resolves a path against the client's `base_url`, hands a
parameters type from `Types` to `<Provider>Session`, and returns the decoded result.

## Layout

```text
API/OpenAI/{SyncAPI, SyncAPI/Beta, AsyncAPI, AsyncAPI/Beta}
API/Anthropic/{SyncAPI, AsyncAPI}
API/TypeSafe/{SyncAPI, AsyncAPI}
API/OpenAI/OpenAIHelper.swift
```

Each provider has one `<Provider>...APIResource.swift` declaring an enum namespace whose nested
`struct ...Resource: ~Copyable` types are handles over `ClientOption`. The calls themselves live in a
file per resource as `public extension <Namespace>.<Resource>`, so adding an endpoint never touches
the namespace file. `OpenAIHelper.swift` is the AVFoundation microphone/player pair that feeds realtime
audio.

Names follow the provider's REST path: `client.chat.completions` is `/chat/completions`,
`client.images.generate` is `/images/generations`, `client.decisions.create` is `/decisions`, and
`client.beta.realtime` is the beta namespace.

## Call shapes

| Kind | Sync | Async |
| --- | --- | --- |
| one-shot | `throws -> Result` | `async throws -> Result` |
| streaming | `SyncThrowingStream<Result, any Error>` | `AsyncThrowingStream<Result, any Error>` |
| paged lists | `SyncThrowingPages<Item>` | `AsyncThrowingPages<Item>` |
| websocket | `connect(completion:)` | `conntent(completion:)` |

The async websocket entry point is spelled `conntent` today, while the sync one is `connect`.

The snippets below reuse the clients from [Client](../Client/README.md): `openAIAsyncClient` is an
`AsyncOpenAI`, `openAISyncClient` an `OpenAI`.

## One-shot and streaming

`create` forces `stream = false` on the parameters copy it sends, `stream` forces `stream = true`, so
one parameters type serves both.

```swift
let response = try await openAIAsyncClient.responses.create(
    parameters: .init(model: "your-model", input: "who are you?")
)
print(response.output_text)

let stream = try await openAIAsyncClient.chat.completions.stream(
    parameters: .init(model: "your-model", messages: [.user("Tell me a story.")])
)
for try await chunk in stream {
    print(chunk.choices.first?.delta.content ?? "", terminator: "")
}
```

## Decision

`decisions.create` sends `DecisionCreateParameters` and returns a `DecisionResult`. Answers are
positionally aligned with the request's questions. Named question variants take `name` as their first
initializer parameter.

```swift
let parameters: DecisionCreateParameters = .init(
    input: .string("I was charged twice. Please fix this ASAP."),
    model: "your-model",
    questions: [
        .predicate(name: "billing", instructions: "Is this ticket about billing?"),
        .choice(
            name: "tone",
            instructions: "What is the customer's tone?",
            choices: ["calm", "frustrated", "angry"]
        ),
        .score(
            name: "urgency",
            instructions: "How urgent is this ticket?",
            levels: ["can wait", "this week", "today"]
        ),
    ]
)

let result = try await openAIAsyncClient.decisions.create(parameters: parameters)
for (question, answer) in zip(parameters.questions, result.answers) {
    print(question.type, answer.type)
}
```

The sync client returns `SyncThrowingStream`, which is a `SyncSequence` rather than a `Sequence`, so it is
drained with `forEach`. Returning `nil` from the closure stops early; falling off the end of the body
keeps going.

```swift
let stream = try openAISyncClient.responses.stream(
    parameters: .init(model: "your-model", input: "Tell me a short story.")
)
var seen = 0
try stream.forEach { chunk in
    print(chunk)
    seen += 1
    if seen >= 10 { return nil }
}
```

## Paged lists

`list` on a paged endpoint hands back pages, not items: one request per iteration, stopping when a page
reports `has_more == false` or comes back empty. Each element is a `PageStruct<Item>` with `data` and
`has_more`.

```swift
let pages = try await openAIAsyncClient.files.list(parameters: .init(limit: 5))
for try await page in pages {
    print(page.data)
}

try openAISyncClient.videos.list().forEach { page in
    print(page.data)
}
```

## Multipart uploads

Calls that carry a file pass `hasFile: true` to the session, which encodes the body as
`multipart/form-data` and flattens nested fields into bracketed names. `Accept` is set for you when an
endpoint returns binary.

```swift
let file = try await openAIAsyncClient.files.create(
    parameters: .init(
        file: try .init(url: URL(fileURLWithPath: "/path/to/file.txt")),
        purpose: "file-extract"
    )
)
let retrieved = try await openAIAsyncClient.files.retrieve(file_id: file.id)
_ = try await openAIAsyncClient.files.delete(file_id: file.id)

// Chunked upload in one call: split, upload parts, complete.
let upload = try await openAIAsyncClient.uploads.upload_file_chunked(
    parameters: .init(
        file: .data(Data(repeating: 0, count: 1024)),
        filename: "data.bin",
        mime_type: "application/octet-stream",
        purpose: "assistants"
    )
)
```

A `Data` stream writes straight to disk, which is how speech and video downloads are saved:

```swift
try await openAIAsyncClient.audio.speech
    .stream(parameters: .init(model: "tts-1", input: "Hello", voice: "alloy"))
    .write(to: URL(fileURLWithPath: "hello.mp3"))
```

## Tools

A tool is one type: `ToolProtocol` plus a `@MainArgument` argument struct whose JSON Schema is
generated by the macros. Registration is the same `.init(Tool.self)` shape on all three providers. See
[SimpleOpenAIKitMacro](../../SimpleOpenAIKitMacro/README.md) for the schema macros.

```swift
var parameters: ResponseCreateParameters = .init(model: "your-model", input: "What's the weather?")
parameters.tools = [.init(WeatherTool.self)]

let response = try await openAIAsyncClient.responses.create(parameters: parameters)
for item in response.output {
    guard case .function_call(let call) = item else { continue }
    let arguments = try JSONDecoder().decode(WeatherTool.Argument.self, from: Data(call.arguments.utf8))
    print(try await WeatherTool.call(arguments: arguments))
}
```

## Structured Outputs

A required answer shape is one type as well: a `@MainArgument` struct that declares `SchemaProtocol`.
The macro already writes the JSON Schema of the struct, the `MainArgument` conformance, and the
metadata next to it — `__name` (the type's own name), `__description` and `__strict`, spelled through
the `description:` and `strict:` labels — so the struct is both what the request describes and what the
answer decodes into, and one macro covers a tool argument and an output shape alike. The `__` prefix
keeps those three apart from the `name`, `description` and `strict` a `ToolProtocol` declares itself. A
type the schema points at instead of inlining carries `@ReferArgument`, the same definition a tool uses,
and is referenced with `@ReferToolArgument`. See
[SimpleOpenAIKitMacro](../../SimpleOpenAIKitMacro/README.md) for the schema macros.

```swift
@ReferArgument
struct Location {
    let lat: Float
    let long: Float
}

@MainArgument(description: "Fetch the weather for a given location.", strict: true)
struct Weather: SchemaProtocol {
    @ReferToolArgument(description: "The location to fetch the weather for.")
    let location: Location
    let time: Double
}
```

The type drops into the format field each provider exposes: `ChatResponseFormat(Weather.self)` for
`chat.completions`, `ResponseFormatTextConfig(Weather.self)` for `responses` under `text.format`,
and `MessageJSONOutputFormat(Weather.self)` for Anthropic `messages` under `output_config.format`,
where only the schema is sent. A `description` or `strict` the caller leaves out is generated as
`nil`, which keeps the provider default.

All three providers expose `parse`: `chat.completions.parse` takes `ChatParseParameters`,
`responses.parse` takes `ResponseParseParameters`, and Anthropic `messages.parse` takes
`MessageParseParameters`. Each method builds the provider's format field from the schema type,
sends a non-streaming request, and returns the original response with decoded values attached to
its text content.

```swift
let chat = try await openAIAsyncClient.chat.completions.parse(
    parameters: .init(
        model: "your-model",
        messages: [.user("What's the weather in New York?")],
        response_format: Weather.self
    )
)
print(chat.choices.first?.message.parsed as Any)      // Weather?

let response = try await openAIAsyncClient.responses.parse(
    parameters: .init(
        model: "your-model",
        input: "What's the weather in New York?",
        text_format: Weather.self
    )
)
for item in response.output {
    if case .message(let message) = item {
        print(message.parsed as Any)                  // Weather?
    }
}

let anthropic = AsyncAnthropic(api_key: "YOUR_ANTHROPIC_API_KEY")
let message = try await anthropic.messages.parse(
    parameters: .init(
        model: "your-anthropic-model",
        messages: [.user("What's the weather in New York?")],
        output_format: Weather.self,
        max_tokens: 1024
    )
)
for block in message.content {
    if case .text(let textBlock) = block {
        print(textBlock.parsed as Any)                // Weather?
    }
}
```

`parsed` is `nil` when the target text is empty, and malformed JSON throws. The `create` methods
remain available whenever you would rather decode the raw content yourself.

## Websockets

`connect`/`conntent` opens the socket, runs your closure against the live connection, then closes it.
The connection is a reference type because it owns the socket: iterate it for server events and push
client events with `send(event:)`, which takes a `RealtimeEventParameters`. The sync connection exposes
`recv()` for one event at a time.

```swift
try await openAIAsyncClient.realtime.conntent(model: "your-realtime-model") { connection in
    for await event in connection {
        print(event)
    }
}

// The Responses API websocket works the same way, over a stream of `ResponseStreamResult`.
try await openAIAsyncClient.responses.conntent { connection in
    for await event in connection {
        print(event)
    }
}

// Blocking form, ending when the buffer is drained or the socket closes.
try openAISyncClient.realtime.connect(model: "your-realtime-model") { connection in
    while let event = connection.recv() {
        print(event)
    }
}
```

## Other providers

Same four shapes, different endpoints. `messages.count_tokens` is a separate POST, not a dry run of
`create`.

```swift
let anthropic = AsyncAnthropic(api_key: "YOUR_ANTHROPIC_API_KEY")
let reply = try await anthropic.messages.create(
    parameters: .init(
        model: "your-anthropic-model",
        messages: [.init(role: .user, content: "Tell me a short story.")],
        max_tokens: 1024
    )
)
let cost = try await anthropic.messages.count_tokens(
    parameters: .init(
        model: "your-anthropic-model",
        messages: [.init(role: .user, content: "Tell me a short story.")]
    )
)
print(cost.usage.input_tokens)

let typeSafe = AsyncTypeSafeClient(api_key: "YOUR_TYPESAFE_API_KEY")
let judgement = try await typeSafe.system_one(
    parameters: .init(
        model: "jev-latest",                       // omit to fall back to the client's model
        state: ["ticket": "I was charged twice."],
        questions: ["billing": .noul(instructions: "Is this billing?")]
    )
)
print(judgement.nouls["billing"]?.noul ?? "None")
```

## Audio helpers

`OpenAIHelper.swift` adds an AVFoundation pair for realtime work, gated by `canImport(AVFoundation)`. Both
resample to `targetFormat`, which is optional for capture but required before playing raw `Data` or a
`Data` stream (`AVAudioPlayerHelper.PlaybackError.targetFormatRequired`).

```swift
let pcm = AudioFormat(sampleRate: 24_000, channelCount: 1)

// One-shot capture: stops when `shouldRecord` says so or `timeout` expires.
let recorded: Data = try await AVMicrophoneHelper(targetFormat: pcm, timeout: 3).record()

// Or stream it into a live realtime connection as it is captured.
let chunks: AsyncStream<Data> = try await AVMicrophoneHelper(targetFormat: pcm).record()
for await chunk in chunks {
    try await connection.send(
        event: .input_audio_buffer_append(.init(audio: chunk.base64EncodedString()))
    )
}

// Play the audio a response produces.
try await AVAudioPlayerHelper(targetFormat: pcm).play(replyAudio)   // AsyncStream<Data>
```

## Rules

- `requestOptions:` is always last and always optional; nothing else is per-call configurable.
- File-carrying calls (images edit, files, uploads, video inputs) pass `hasFile: true` and get a
  multipart body from the session.
- Every call goes through `<Provider>Session.shared`; no URLSession here.
- Realtime connections also expose sub-resources per connection
  (`connection.session.update(...)`, `connection.conversation.item.create(...)`,
  `connection.input_audio_buffer.append(...)`), and those methods are `public`. `send(event:)` stays
  public too, for events without a dedicated sub-resource.
- `requestOptions:` overrides are currently module-internal too: `RequestOptions`' members lost their
  `public`, so `extra_body`, `extra_headers`, `extra_query` and `timeout` cannot be set from a client
  package yet.

# SimpleOpenAIKit

中文 | [English](README.md)

## 目录

- [简介](#简介)
- [安装](#安装)
- [Requirements](#requirements)
- [OpenAI](#openai)
  - [支持列表](#openai-支持列表)
  - [定义 Client](#openai-定义-client)
  - [Usage](#usage)
    - [Vision](#vision)
    - [Tool](#tool)
    - [Request Option](#request-option)
  - [Async Response](#async-response)
  - [Stream](#stream)
  - [Chat](#chat)
  - [Embedding](#embedding)
  - [Audio](#audio)
  - [Models](#models)
  - [Completions](#completions)
  - [Images](#images)
  - [Files](#files)
  - [Uploads](#uploads)
  - [Videos](#videos)
  - [Realtime](#realtime)
  - [Beta Realtime](#beta-realtime)
- [Anthropic](#anthropic)
  - [支持列表](#anthropic-支持列表)
  - [Message](#message)
- [TypeSafe](#typesafe)
  - [支持列表](#typesafe-支持列表)
  - [System One](#system-one)
- [License](#license)

## 简介

SimpleOpenAIkit 是专为 Swift 开发者打造的轻量级客户端，旨在填补 OpenAI 官方 Swift SDK 的空白，为 Swift 开发者提供一种无缝、高效且符合 Swift 风格的方式来与 OpenAI 的 REST 接口交互。该项目主要受 [OpenAIKit](https://github.com/OpenDive/OpenAIKit) 和 [openai-python](https://github.com/openai/openai-python) 启发，使得可以更快的的将 `openai-python` 迁移集成到应用中。此外，该项目同时集成 Anthropic API，能够更加方便的调用不同的模型。

## 安装

[Swift Package Manager](https://swift.org/package-manager/) 让开发者可以轻松地将包集成到 Xcode 项目和包中，并且已完整集成到 Swift 编译器中。

#### 通过 Xcode 项目使用 SPM

1. File > Swift Packages > Add Package Dependency
2. 添加 `https://github.com/snowscattered/SimpleOpenAIKit.git`
3. 选择 "Up to next Major"，版本填写 "1.0.0"

#### 通过 Xcode Package 使用 SPM

在搭建好 Swift package 后，将 Git 地址添加到 `Package.swift` 的 `dependencies` 中。

```swift
dependencies: [
    .package(url: "https://github.com/snowscattered/SimpleOpenAIKit.git", .upToNextMajor(from: "1.0.0"))
]
```

## Requirements

| 平台 | 最低 Swift 版本 | 安装方式 | 状态 |
| --- | --- | --- | --- |
| iOS 13.0+ / macOS 12.0+ / tvOS 13.0+ / watchOS 6.0+ / Mac Catalyst 13.0+ | 6.3 | [Swift Package Manager](#安装) | Fully Tested |

## OpenAI

### OpenAI 支持列表

以下列表以 `Sources/SimpleOpenAIKit/Clinet/OpenAI/OpenAI.swift` 中的顶层属性为基准；`✅` 表示已启用，`❌` 表示在该文件中仍被注释、尚未支持。`AsyncOpenAI.swift` 使用同一套命名空间的 Async 版本。

| 命名空间 | OpenAI.swift 状态 | 当前提供的主要方法 |
| --- | --- | --- |
| `models` | ✅ | `list`, `retrieve`, `delete` |
| `completions` | ✅ | `create`, `stream` |
| `chat.completions` | ✅ | `create`, `stream` |
| `embeddings` | ✅ | `create` |
| `images` | ✅ | `generate`, `edit`, `generateStream`, `editStream` |
| `audio` | ✅ | `speech.create`, `speech.stream`, `transcriptions.create`, `transcriptions.stream` |
| `responses` | ✅ | `create`, `stream` |
| `files` | ✅ | `create`, `list`, `retrieve`, `delete` |
| `uploads` | ✅ | `create`, `cancel`, `complete`, `upload_file_chunked`, `part.create` |
| `videos` | ✅ | `create`, `list`, `retrieve`, `delete`, `edit`, `create_character`, `create_and_poll` |
| `realtime` | ✅ | `connect`, `send`, `recv`，以及 session / response / item 相关事件方法 |
| `beta.realtime` | ✅ | 现在仅支持 `Realtime` |
| `vector_stores` | ❌ | - |
| `batches` | ❌ | - |
| `fine_tuning` | ❌ | - |
| `containers` | ❌ | - |
| `skills` | ❌ | - |
| `moderations` | ❌ | - |
| `webhooks` | ❌ | - |
| `conversations` | ❌ | - |
| `evals` | ❌ | - |

### OpenAI 定义 Client

```swift
import Foundation
import SimpleOpenAIKit

let openAISyncClient = OpenAI(api_key: "YOUR_API_KEY")
let openAIAsyncClient = AsyncOpenAI(api_key: "YOUR_API_KEY")
```

如需指向自定义网关，可以传入 `base_url`：

```swift
let openAIAsyncClient = AsyncOpenAI(
    api_key: "YOUR_API_KEY",
    base_url: URL(string: "https://your-gateway.example.com/v1")
)
```

### Usage

> **警告**：OpenAI 的 Sync 客户端目前是测试性质的 API，仅建议用于测试或快速验证，正式项目推荐使用 `AsyncOpenAI`。

```swift
func openAISyncResponse() throws {
    let response = try openAISyncClient.responses.create(
        parameters: .init(
            model: "your-model",
            input: "who are you?"
        )
    )
    print(response.output_text)
}

func openAISyncResponseStream() throws {
    let stream = try openAISyncClient.responses.stream(
        parameters: .init(
            model: "your-model",
            input: "Tell me a short story."
        )
    )

    try stream.forEach { chunk in
        print(chunk)
    }
}
```

#### Vision

```swift
func openAIVisionExample() throws {
    let params: ResponseParameters = .init(
        model: "your-model",
        input: [
            .user(.array([
                .input_text(""),
                .input_image(.init(image_url: ""))
            ]))
        ],
    )

    let response = try openAISyncClient.responses.create(
        parameters: params
    )
    print(response.output_text)
}
```

#### Tool

Chat、Message 和 Response 使用统一的 Tool 定义与格式，均通过 `.init(Tool.self)` 添加工具，区别只在参数类型及其 `tools` 属性。

> **提示**：同一个 Tool 也可以与 Foundation Models 的 `Tool` 一起使用。这里不会自动生成兼容层，因此需要自行添加 Foundation Models 的 `Tool` 协议实现，并为参数类型添加 `@Generable` 宏。

```swift
struct WeatherTool: ToolProtocol {
    static let name: String = "fetch_weather"
    static let description: String = "Fetch the weather for a given location."
    static let strict: Bool? = true

    @ReferArgument
    struct Location {
        let lat: Float
        let long: Float
    }

    @MainArgument
    struct Argument {
        @ReferToolArgument(description: "The location to fetch the weather for.")
        let location: Location
        let time: Double
    }

    static func call(arguments: Argument) async throws -> String {
        "sunny"
    }
}

func openAIToolExample() async throws {
    var parameters: ResponseCreateParameters = .init(
        model: "your-model",
        input: "Could you fetch the current weather for lat=40.7128, lon=-74.0060? Also tell me what it'll be like in 5 hours?"
    )
    parameters.tools = [.init(WeatherTool.self)]

    let response = try await openAIAsyncClient.responses.create(
        parameters: parameters
    )

    for item in response.output {
        switch item {
        case .function_call(let functionCall):
            let arguments = try JSONDecoder().decode(
                WeatherTool.Argument.self,
                from: Data(functionCall.arguments.utf8)
            )
            print(try await WeatherTool.call(arguments: arguments))
        default:
            continue
        }
    }
}
```

同一个 Tool 定义也可分别用于 `ChatParameters.tools`、`MessageParameters.tools` 和 `ResponseParameters.tools`：

```swift
let chatTools: [ChatTool] = [.init(WeatherTool.self)]
let messageTools: [MessageTool] = [.init(WeatherTool.self)]
let responseTools: [ResponseTool] = [.init(WeatherTool.self)]
```

#### Request Option

```swift
func requestOption() throws {
    let params: ResponseParameters = .init(
        model: "your-model",
        input: "who are you?"
    )

    let response = try openAISyncClient.responses.create(
        parameters: params,
        requestOptions: .init(
            extra_body: [
                "": ""
            ],
            extra_headers: [
                "": ""
            ]
        )
    )
    print(response)
}
```

### Async Response

```swift
func openAIAsyncResponse() async throws {
    let response = try await openAIAsyncClient.responses.create(
        parameters: .init(
            model: "your-model",
            input: "who are you?"
        )
    )
    print(response.output_text)
}
```

### Stream

```swift
func openAIAsyncStream() async throws {
    let stream = try await openAIAsyncClient.responses.stream(
        parameters: .init(
            model: "your-model",
            input: "Tell me a short story."
        )
    )

    for try await chunk in stream {
        print(chunk)
    }
}
```

> **警告**：OpenAI 的 Sync 客户端目前是测试性质的 API，仅建议用于测试或快速验证，正式项目推荐使用 `AsyncOpenAI`。

```swift
func openAISyncStream() throws {
    let stream = try openAISyncClient.responses.stream(
        parameters: .init(
            model: "your-model",
            input: "Tell me a short story."
        )
    )

    try stream.forEach { chunk in
        print(chunk)
    }
}
```

### Chat

```swift
func openAIAsyncChat() async throws {
    let response = try await openAIAsyncClient.chat.completions.create(
        parameters: .init(
            model: "your-model",
            messages: [
                .user("Hello!")
            ]
        )
    )
    print(response.choices.first?.message.content ?? "No Content")
}

func openAIAsyncChatStream() async throws {
    let stream = try await openAIAsyncClient.chat.completions.stream(
        parameters: .init(
            model: "your-model",
            messages: [
                .user("Tell me a story.")
            ]
        )
    )

    for try await chunk in stream {
        if let content = chunk.choices.first?.delta.content {
            print(content, terminator: "")
        }
    }
}
```

### Embedding

```swift
func openAIAsyncEmbedding() async throws {
    let result = try await openAIAsyncClient.embeddings.create(
        parameters: .init(
            model: "your-embedding-model",
            input: "Hello",
            dimensions: 1024
        )
    )
    print(result.data.first?.embedding.count ?? 0)
}
```

### Audio

```swift
func openAIAsyncSpeech() async throws {
    let audio = try await openAIAsyncClient.audio.speech.create(
        parameters: .init(
            model: "your-tts-model",
            input: "Hello!",
            voice: "alloy",
            response_format: .wav
        )
    )
    try audio.write(to: URL(fileURLWithPath: "/tmp/hello.wav"))
}

func openAIAsyncSpeechStream() async throws {
    let stream = try await openAIAsyncClient.audio.speech.stream(
        parameters: .init(
            model: "your-tts-model",
            input: "Hello!",
            voice: "alloy",
            response_format: .wav
        )
    )

    for try await chunk in stream {
        print(chunk.count)
    }
}

func openAIAsyncTranscription() async throws {
    let result = try await openAIAsyncClient.audio.transcriptions.create(
        parameters: try .init(
            model: "your-asr-model",
            file: .init(url: URL(fileURLWithPath: "/path/to/audio.wav"))
        )
    )
    print(result)
}

func openAIAsyncTranscriptionStream() async throws {
    let stream = try await openAIAsyncClient.audio.transcriptions.stream(
        parameters: try .init(
            model: "your-asr-model",
            file: .init(url: URL(fileURLWithPath: "/path/to/audio.wav"))
        )
    )

    for try await chunk in stream {
        print(chunk)
    }
}
```

### Models

```swift
func openAIAsyncModels() async throws {
    let models = try await openAIAsyncClient.models.list()
    print(models.data)

    let model = try await openAIAsyncClient.models.retrieve(model: "your-model")
    print(model)

    _ = try await openAIAsyncClient.models.delete(model: "your-model")
}
```

### Completions

```swift
func openAIAsyncCompletions() async throws {
    let response = try await openAIAsyncClient.completions.create(
        parameters: .init(
            model: "your-model",
            prompt: "def fib(a):",
            suffix: "    return fib(a-1) + fib(a-2)",
            max_tokens: 128
        )
    )
    print(response.choices.first?.text ?? "No Content")
}

func openAIAsyncCompletionsStream() async throws {
    let stream = try await openAIAsyncClient.completions.stream(
        parameters: .init(
            model: "your-model",
            prompt: "def fib(a):"
        )
    )

    for try await chunk in stream {
        print(chunk)
    }
}
```

### Images

```swift
func openAIAsyncImageGenerate() async throws {
    let result = try await openAIAsyncClient.images.generate(
        parameters: .init(
            model: "your-image-model",
            prompt: "A cute cat on a sunny windowsill",
            size: "1280x1280"
        )
    )
    print(result)
}

func openAIAsyncImageGenerateStream() async throws {
    let stream = try await openAIAsyncClient.images.generateStream(
        parameters: .init(
            model: "your-image-model",
            prompt: "A cute cat on a sunny windowsill"
        )
    )

    for try await chunk in stream {
        print(chunk)
    }
}
```

### Files

```swift
func openAIAsyncFiles() async throws {
    let file = try await openAIAsyncClient.files.create(
        parameters: .init(
            file: try .init(url: URL(fileURLWithPath: "/path/to/file.txt")),
            purpose: "file-extract"
        )
    )
    print(file)

    let pages = try await openAIAsyncClient.files.list(
        parameters: .init(limit: 5)
    )
    for try await page in pages {
        print(page.data)
    }

    let retrieved = try await openAIAsyncClient.files.retrieve(file_id: file.id)
    print(retrieved)

    _ = try await openAIAsyncClient.files.delete(file_id: file.id)
}
```

### Uploads

```swift
func openAIAsyncUploads() async throws {
    let upload = try await openAIAsyncClient.uploads.create(
        parameters: .init(
            bytes: 1024,
            filename: "data.bin",
            mime_type: "application/octet-stream",
            purpose: "assistants"
        )
    )
    print(upload)

    let result = try await openAIAsyncClient.uploads.upload_file_chunked(
        parameters: .init(
            file: .data(Data(repeating: 0, count: 1024)),
            filename: "data.bin",
            mime_type: "application/octet-stream",
            purpose: "assistants"
        )
    )
    print(result)
}
```

### Videos

```swift
func openAIAsyncVideos() async throws {
    let video = try await openAIAsyncClient.videos.create(
        parameters: .init(
            model: "your-video-model",
            prompt: "A city timelapse"
        )
    )
    print(video)

    let pages = try await openAIAsyncClient.videos.list()
    for try await page in pages {
        print(page.data)
    }

    let detail = try await openAIAsyncClient.videos.retrieve(video_id: video.id)
    print(detail)

    _ = try await openAIAsyncClient.videos.delete(video_id: video.id)
}
```

### Realtime

```swift
func openAIAsyncRealtime() async throws {
    try await openAIAsyncClient.realtime.conntent(model: "your-realtime-model") { connection in
        for await event in connection {
            print(event)
        }
    }
}
```

### Beta Realtime

```swift
func openAIAsyncBetaRealtime() async throws {
    try await openAIAsyncClient.beta.realtime.conntent(model: "your-realtime-model") { connection in
        for await event in connection {
            print(event)
        }
    }
}
```

## Anthropic

### Anthropic 支持列表

以下列表以 `Sources/SimpleOpenAIKit/Clinet/Anthropic/Anthropic.swift` 中的顶层属性为基准；`✅` 表示已启用，`❌` 表示在该文件中仍被注释、尚未支持。`AsyncAnthropic.swift` 使用同一套命名空间的 Async 版本。

| 命名空间 | Anthropic.swift 状态 | 当前提供的主要方法 |
| --- | --- | --- |
| `models` | ✅ | `list`, `retrieve` |
| `completions` | ✅ | `create`, `stream` |
| `messages` | ✅ | `create`, `stream`, `count_tokens` |

### Message

```swift
func anthropicMessageStream() async throws {
    let anthropic = AsyncAnthropic(api_key: "YOUR_ANTHROPIC_API_KEY")
    let stream = try await anthropic.messages.stream(
        parameters: .init(
            model: "your-anthropic-model",
            messages: [
                .init(role: .user, content: "Tell me a short story.")
            ],
            max_tokens: 1024
        )
    )

    for try await chunk in stream {
        print(chunk)
    }
}
```

## TypeSafe

### TypeSafe 支持列表

以下列表以 `Sources/SimpleOpenAIKit/Clinet/TypeSafe/TypeSafeClient.swift` 中的顶层属性为基准；`✅` 表示已启用，`❌` 表示在该文件中仍被注释、尚未支持。`AsyncTypeSafeClient.swift` 使用同一套命名空间的 Async 版本。

| 命名空间 | TypeSafeClient.swift 状态 | 当前提供的主要方法 |
| --- | --- | --- |
| `systemOne` | ✅ | `system_one` |
| `models` | ✅ | `list` |

`systemOne` 保持模块内可见，并在 client 上做了桥接，所以调用写成 `client.system_one(parameters:)`。创建 client 时传入 `api_key`；请求没有写 `SystemOneParameters.model` 时使用 client 的 `model`（默认 `jev-latest`），`base_url` 默认是 `https://api.typesafe.ai`。

### System One

一次请求把同一个 `state` 交给一组带类型的 `questions` 评估，答案按提问时用的 key 返回。彼此独立的问题并行执行、也看不到彼此的答案，流程仍然由代码掌握，模型只给出概率。

```swift
func typeSafeSystemOne() async throws {
    let client = AsyncTypeSafeClient(api_key: "YOUR_TYPESAFE_API_KEY")
    let response = try await client.system_one(
        parameters: .init(
            state: ["document": "I was charged twice. Please fix this ASAP."],
            questions: [
                "billing": .noul(instructions: "Is this ticket about billing?"),
                "tone": .choice(
                    instructions: "What is the customer's tone?",
                    criteria: ["calm": nil, "frustrated": nil, "angry": nil]
                ),
                "urgency": .score(
                    instructions: "How urgent is this ticket?",
                    criteria: ["can wait", "this week", "today"]
                ),
            ]
        )
    )

    print(response.nouls["billing"]?.noul ?? "None")
    print(response.choices["tone"]?.choice ?? "None")
    print(response.scores["urgency"]?.score ?? "None")
}
```

`nouls`、`choices`、`scores` 按问题类型分组取答案，`answers` 保留每个提问 key 的原始答案，`usage` 给出 token 用量。Score 答案另有 `probability(forLevel:)`、`legend(forLevel:)` 与 `levels`；Choice 和 Score 答案带 `confidence`，Noul 答案没有单独的置信度，因为它的概率本身就已经说明了不确定性。

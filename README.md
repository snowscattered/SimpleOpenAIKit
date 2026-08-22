# SimpleOpenAIKit

English | [中文](README.zh-CN.md)

## Table of Contents

- [Introduction](#introduction)
- [Installation](#installation)
- [Requirements](#requirements)
- [OpenAI](#openai)
  - [Supported Resources](#openai-supported-resources)
  - [Define a Client](#openai-define-a-client)
  - [Usage](#usage)
    - [Vision](#vision)
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
  - [Supported Resources](#anthropic-supported-resources)
  - [Message](#message)
- [License](#license)

## Introduction

SimpleOpenAIkit is a lightweight client built specifically for Swift developers, designed to fill the gap left by the absence of an official OpenAI Swift SDK. It provides a seamless, efficient, and Swift‑native way to interact with OpenAI’s REST APIs. This project is primarily inspired by [OpenAIKit](https://github.com/OpenDive/OpenAIKit) and [openai-python](https://github.com/openai/openai-python), enabling developers to quickly migrate and integrate their existing `openai-python` code into Swift applications with minimal friction. In addition, it also includes built‑in support for the Anthropic API, making it easy to switch between different model providers as needed.

## Installation

The [Swift Package Manager](https://swift.org/package-manager/) allows developers to easily integrate packages into Xcode projects and packages, and is fully integrated into the Swift compiler.

#### SPM Through Xcode Project

1. File > Swift Packages > Add Package Dependency
2. Add `https://github.com/snowscattered/SimpleOpenAIKit.git`
3. Select "Up to next Major" with "1.0.0"

#### SPM Through Xcode Package

Once you have your Swift package set up, add the Git link within the dependencies value of your `Package.swift` file.

```swift
dependencies: [
    .package(url: "https://github.com/snowscattered/SimpleOpenAIKit.git", .upToNextMajor(from: "1.0.0"))
]
```

## Requirements

| Platform | Minimum Swift Version | Installation | Status |
| --- | --- | --- | --- |
| iOS 13.0+ / macOS 12.0+ / tvOS 13.0+ / watchOS 6.0+ / Mac Catalyst 13.0+ | 6.3 | [Swift Package Manager](#installation) | Fully Tested |

## OpenAI

### OpenAI Supported Resources

The following list is based on the top-level properties in `Sources/SimpleOpenAIKit/Clinet/OpenAI/OpenAI.swift`; `✅` means enabled, `❌` means still commented out and not yet supported. `AsyncOpenAI.swift` exposes the same namespace list in its Async variants.

| Namespace | OpenAI.swift Status | Primary Methods |
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
| `realtime` | ✅ | `connect`, `send`, `recv` (`revc` in Async), plus session / response / item event methods |
| `beta.realtime` | ✅ |now olny supprot `Realtime`  |
| `vector_stores` | ❌ | - |
| `batches` | ❌ | - |
| `fine_tuning` | ❌ | - |
| `containers` | ❌ | - |
| `skills` | ❌ | - |
| `moderations` | ❌ | - |
| `webhooks` | ❌ | - |
| `conversations` | ❌ | - |
| `evals` | ❌ | - |

### OpenAI Define a Client

```swift
import Foundation
import SimpleOpenAIKit

let openAISyncClient = OpenAI(api_key: "YOUR_API_KEY")
let openAIAsyncClient = AsyncOpenAI(api_key: "YOUR_API_KEY")
```

To point at a custom gateway, pass `base_url`:

```swift
let openAIAsyncClient = AsyncOpenAI(
    api_key: "YOUR_API_KEY",
    base_url: URL(string: "https://your-gateway.example.com/v1")
)
```

### Usage

> **Warning**: The OpenAI sync client is experimental and intended for testing or quick verification. Prefer `AsyncOpenAI` in production.

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

> **Warning**: The OpenAI sync client is experimental and intended for testing or quick verification. Prefer `AsyncOpenAI` in production.

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

### Anthropic Supported Resources

Anthropic Message API is supported through `AsyncAnthropic` / `Anthropic`:

| Namespace | Client | Primary Methods |
| --- | --- | --- |
| `messages` | `AsyncAnthropic` / `Anthropic` | `create`, `stream` |
| `models` | `AsyncAnthropic` / `Anthropic` | `list`, `retrieve` |
| `completions` | `AsyncAnthropic` / `Anthropic` | `create`, `stream` |

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

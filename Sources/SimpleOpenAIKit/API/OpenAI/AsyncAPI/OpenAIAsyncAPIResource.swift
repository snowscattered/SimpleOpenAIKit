//
//  OpenAIAsyncAPIResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/8/26.
//

/// Namespaces of the awaitable OpenAI client; each struct is a handle holding the client options.
///
/// Mirrors `OpenAISyncAPIResource`; endpoint methods live in `public extension` files beside them.
public enum OpenAIAsyncAPIResource {
    // MARK: Model
    /// `/models`: list, retrieve, delete a model.
    public struct ModelsAsyncResource: ~Copyable, ResourceProtocol {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    // MARK: Completions
    /// `/completions`: the legacy text completion endpoint, plus its streaming variant.
    public struct CompletionsAsyncResource: ~Copyable, ResourceProtocol {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    // MARK: Chat
    /// `/chat/completions`: chat requests and streamed chat chunks.
    public struct ChatCompletionsAsyncResource: ~Copyable, ResourceProtocol {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    /// Groups `chat.completions` under `client.chat`.
    public struct ChatsAsyncResource: ~Copyable, ResourceProtocol {
        let clientOption: OpenAIClientOption
        public let completions: ChatCompletionsAsyncResource
        init(_ clientOption: OpenAIClientOption) {
            self.clientOption = clientOption
            self.completions = ChatCompletionsAsyncResource(clientOption)
        }
    }

    // MARK: Embedding
    /// `/embeddings`: turn text into vectors.
    public struct EmbeddingsAsyncResource: ~Copyable, ResourceProtocol {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    // MARK: Image
    /// `/images/generations`: create images from a prompt.
    public struct ImageGenerateAsyncResource: ~Copyable, ResourceProtocol {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    /// `/images/edits` and `/images/variations`: multipart image rework.
    public struct ImageEditAsyncResource: ~Copyable, ResourceProtocol {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    /// Groups `images.generate` and `images.edit` under `client.images`.
    public struct ImagesAsyncResource: ~Copyable, ResourceProtocol {
        let clientOption: OpenAIClientOption
        public let generate: ImageGenerateAsyncResource
        public let edit: ImageEditAsyncResource
        init(_ clientOption: OpenAIClientOption) {
            self.clientOption = clientOption
            self.generate = ImageGenerateAsyncResource(clientOption)
            self.edit = ImageEditAsyncResource(clientOption)
        }
    }

    // MARK: Audio
    /// `/audio/speech`: text to speech, returned as raw audio bytes.
    public struct AudioSpeechAsyncResource: ~Copyable, ResourceProtocol {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    /// `/audio/transcriptions`: speech to text, optionally streamed.
    public struct AudioTranscriptionsAsyncResource: ~Copyable, ResourceProtocol {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    /// Groups `audio.speech` and `audio.transcriptions` under `client.audio`.
    public struct AudioAsyncResource: ~Copyable, ResourceProtocol {
        let clientOption: OpenAIClientOption
        public let speech: AudioSpeechAsyncResource
        public let transcriptions: AudioTranscriptionsAsyncResource
        init(_ clientOption: OpenAIClientOption) {
            self.clientOption = clientOption
            self.speech = AudioSpeechAsyncResource(clientOption)
            self.transcriptions = AudioTranscriptionsAsyncResource(clientOption)
        }
    }

    // MARK: Response
    /// Reserved for the response input-item endpoints; no calls are wired up yet.
    public struct ResponsesInputItemsAsyncResource: ~Copyable, ResourceProtocol {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    /// Reserved for response input-token counting; no calls are wired up yet.
    public struct ResponsesInputTokensAsyncResource: ~Copyable, ResourceProtocol {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    /// `/responses`: create, retrieve, cancel, delete, compact, plus websocket access.
    public struct ResponsesAsyncResource: ~Copyable, ResourceProtocol {
        let clientOption: OpenAIClientOption
        public let inputItems: ResponsesInputItemsAsyncResource
        public let inputTokens: ResponsesInputTokensAsyncResource
        init(_ clientOption: OpenAIClientOption) {
            self.clientOption = clientOption
            self.inputItems = ResponsesInputItemsAsyncResource(clientOption)
            self.inputTokens = ResponsesInputTokensAsyncResource(clientOption)
        }
    }

    // MARK: File
    /// `/files`: upload, list, inspect and delete stored files.
    public struct FilesAsyncResource: ~Copyable, ResourceProtocol {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    // MARK: Upload
    /// `/uploads/{id}/parts`: add one part to an in-progress upload.
    public struct UploadsPartAsyncResource: ~Copyable, ResourceProtocol {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    /// `/uploads`: start, complete or cancel a chunked upload.
    public struct UploadsAsyncResource: ~Copyable, ResourceProtocol {
        let clientOption: OpenAIClientOption
        public let part: UploadsPartAsyncResource
        init(_ clientOption: OpenAIClientOption) {
            self.clientOption = clientOption
            self.part = UploadsPartAsyncResource(clientOption)
        }
    }

    // MARK: Video
    /// `/videos`: generate, edit, extend, remix, poll and download videos.
    public struct VideosAsyncResource: ~Copyable, ResourceProtocol {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    // MARK: Realtime
    /// `/realtime`: opens a websocket session and exposes buffered send/receive resources.
    public struct RealtimeAsyncResource: ~Copyable, ResourceProtocol {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }
    
    // MARK: Decision
    public struct DecisionsAsyncResource: ~Copyable, ResourceProtocol {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    // MARK: Beta
    /// Beta realtime websocket session, mirroring `RealtimeAsyncResource` on the `beta` namespace.
    public struct BetaRealtimeAsyncResource: ~Copyable, ResourceProtocol {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    /// Groups `beta.realtime` under `client.beta`.
    public struct BetaAsyncResource: ~Copyable, ResourceProtocol {
        let clientOption: OpenAIClientOption
        public let realtime: BetaRealtimeAsyncResource
        init(_ clientOption: OpenAIClientOption) {
            self.clientOption = clientOption
            self.realtime = BetaRealtimeAsyncResource(clientOption)
        }
    }
}

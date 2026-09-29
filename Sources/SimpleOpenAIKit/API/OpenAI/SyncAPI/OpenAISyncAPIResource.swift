//
//  OpenAISyncAPIResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/31/26.
//

/// Namespaces of the blocking OpenAI client; each struct is a handle holding the client options.
///
/// Endpoint methods live in `public extension` files next to the struct they belong to, so a new
/// endpoint never changes this file.
public enum OpenAISyncAPIResource {
    // MARK: Model
    /// `/models`: list, retrieve, delete a model.
    public struct ModelsSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    // MARK: Completions
    /// `/completions`: the legacy text completion endpoint, plus its streaming variant.
    public struct CompletionsSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    // MARK: Chat
    /// `/chat/completions`: chat requests and streamed chat chunks.
    public struct ChatCompletionsSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    /// Groups `chat.completions` under `client.chat`.
    public struct ChatsSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        public let completions: ChatCompletionsSyncResource
        init(_ clientOption: OpenAIClientOption) {
            self.clientOption = clientOption
            self.completions = ChatCompletionsSyncResource(clientOption)
        }
    }

    // MARK: Embedding
    /// `/embeddings`: turn text into vectors.
    public struct EmbeddingsSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    // MARK: Image
    /// `/images/generations`: create images from a prompt.
    public struct ImageGenerateSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    /// `/images/edits` and `/images/variations`: multipart image rework.
    public struct ImageEditSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    /// Groups `images.generate` and `images.edit` under `client.images`.
    public struct ImagesSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        public let generate: ImageGenerateSyncResource
        public let edit: ImageEditSyncResource
        init(_ clientOption: OpenAIClientOption) {
            self.clientOption = clientOption
            self.generate = ImageGenerateSyncResource(clientOption)
            self.edit = ImageEditSyncResource(clientOption)
        }
    }

    // MARK: Audio
    /// `/audio/speech`: text to speech, returned as raw audio bytes.
    public struct AudioSpeechSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    /// `/audio/transcriptions`: speech to text, optionally streamed.
    public struct AudioTranscriptionsSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    /// Groups `audio.speech` and `audio.transcriptions` under `client.audio`.
    public struct AudioSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        public let speech: AudioSpeechSyncResource
        public let transcriptions: AudioTranscriptionsSyncResource
        init(_ clientOption: OpenAIClientOption) {
            self.clientOption = clientOption
            self.speech = AudioSpeechSyncResource(clientOption)
            self.transcriptions = AudioTranscriptionsSyncResource(clientOption)
        }
    }

    // MARK: Response
    /// Reserved for the response input-item endpoints; no calls are wired up yet.
    public struct ResponsesInputItemsSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    /// Reserved for response input-token counting; no calls are wired up yet.
    public struct ResponsesInputTokensSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    /// `/responses`: create, retrieve, cancel, delete, compact, plus websocket access.
    public struct ResponsesSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        public let inputItems: ResponsesInputItemsSyncResource
        public let inputTokens: ResponsesInputTokensSyncResource
        init(_ clientOption: OpenAIClientOption) {
            self.clientOption = clientOption
            self.inputItems = ResponsesInputItemsSyncResource(clientOption)
            self.inputTokens = ResponsesInputTokensSyncResource(clientOption)
        }
    }

    // MARK: File
    /// `/files`: upload, list, inspect and delete stored files.
    public struct FilesSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }
    
    // MARK: Upload
    /// `/uploads/{id}/parts`: add one part to an in-progress upload.
    public struct UploadsPartSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    /// `/uploads`: start, complete or cancel a chunked upload.
    public struct UploadsSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        public let part: UploadsPartSyncResource
        init(_ clientOption: OpenAIClientOption) {
            self.clientOption = clientOption
            self.part = UploadsPartSyncResource(clientOption)
        }
    }

    // MARK: Video
    /// `/videos`: generate, edit, extend, remix, poll and download videos.
    public struct VideosSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    // MARK: Realtime
    /// `/realtime`: opens a websocket session and exposes buffered send/receive resources.
    public struct RealtimeSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }
    
    
    // MARK: Beta
    /// Beta realtime websocket session, mirroring `RealtimeSyncResource` on the `beta` namespace.
    public struct BetaRealtimeSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    /// Groups `beta.realtime` under `client.beta`.
    public struct BetaSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        public let realtime: BetaRealtimeSyncResource
        init(_ clientOption: OpenAIClientOption) {
            self.clientOption = clientOption
            self.realtime = BetaRealtimeSyncResource(clientOption)
        }
    }
}

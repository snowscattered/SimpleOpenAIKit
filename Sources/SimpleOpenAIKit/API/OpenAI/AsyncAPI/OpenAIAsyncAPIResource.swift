//
//  OpenAIAsyncAPIResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/8/26.
//

public enum OpenAIAsyncAPIResource {
    // MARK: Model
    public struct ModelsAsyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    // MARK: Completions
    public struct CompletionsAsyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    // MARK: Chat
    public struct ChatCompletionsAsyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    public struct ChatsAsyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        public let completions: ChatCompletionsAsyncResource
        init(_ clientOption: OpenAIClientOption) {
            self.clientOption = clientOption
            self.completions = ChatCompletionsAsyncResource(clientOption)
        }
    }

    // MARK: Embedding
    public struct EmbeddingsAsyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    // MARK: Image
    public struct ImageGenerateAsyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    public struct ImageEditAsyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    public struct ImagesAsyncResource: ~Copyable {
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
    public struct AudioSpeechAsyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    public struct AudioTranscriptionsAsyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    public struct AudioAsyncResource: ~Copyable {
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
    public struct ResponsesInputItemsAsyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    public struct ResponsesInputTokensAsyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    public struct ResponsesAsyncResource: ~Copyable {
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
    public struct FilesAsyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    // MARK: Upload
    public struct UploadsPartAsyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    public struct UploadsAsyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        public let part: UploadsPartAsyncResource
        init(_ clientOption: OpenAIClientOption) {
            self.clientOption = clientOption
            self.part = UploadsPartAsyncResource(clientOption)
        }
    }

    // MARK: Video
    public struct VideosAsyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    // MARK: Realtime
    public struct RealtimeAsyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    // MARK: Beta
    public struct BetaRealtimeAsyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    public struct BetaAsyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        public let realtime: BetaRealtimeAsyncResource
        init(_ clientOption: OpenAIClientOption) {
            self.clientOption = clientOption
            self.realtime = BetaRealtimeAsyncResource(clientOption)
        }
    }
}

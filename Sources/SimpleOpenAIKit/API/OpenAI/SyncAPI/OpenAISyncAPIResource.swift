//
//  OpenAISyncAPIResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/31/26.
//

public enum OpenAISyncAPIResource {
    // MARK: Model
    public struct ModelsSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    // MARK: Completions
    public struct CompletionsSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    // MARK: Chat
    public struct ChatCompletionsSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    public struct ChatsSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        public let completions: ChatCompletionsSyncResource
        init(_ clientOption: OpenAIClientOption) {
            self.clientOption = clientOption
            self.completions = ChatCompletionsSyncResource(clientOption)
        }
    }

    // MARK: Embedding
    public struct EmbeddingsSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    // MARK: Image
    public struct ImageGenerateSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    public struct ImageEditSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

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
    public struct AudioSpeechSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    public struct AudioTranscriptionsSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

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
    public struct ResponsesInputItemsSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    public struct ResponsesInputTokensSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

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
    public struct FilesSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }
    
    // MARK: Upload
    public struct UploadsPartSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    public struct UploadsSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        public let part: UploadsPartSyncResource
        init(_ clientOption: OpenAIClientOption) {
            self.clientOption = clientOption
            self.part = UploadsPartSyncResource(clientOption)
        }
    }

    // MARK: Video
    public struct VideosSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    // MARK: Realtime
    public struct RealtimeSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }
    
    
    // MARK: Beta
    public struct BetaRealtimeSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        init(_ clientOption: OpenAIClientOption) { self.clientOption = clientOption }
    }

    public struct BetaSyncResource: ~Copyable {
        let clientOption: OpenAIClientOption
        public let realtime: BetaRealtimeSyncResource
        init(_ clientOption: OpenAIClientOption) {
            self.clientOption = clientOption
            self.realtime = BetaRealtimeSyncResource(clientOption)
        }
    }
}

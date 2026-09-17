//
//  OpenAISyncAPIResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/31/26.
//

public class OpenAISyncAPIResource {
    let clientOption: OpenAIClientOption
    init(_ clientOption: OpenAIClientOption) {
        self.clientOption = clientOption
    }

    // MARK: Model
    public final class ModelsSyncResource: OpenAISyncAPIResource { }
    // MARK: Completions
    public final class CompletionsSyncResource: OpenAISyncAPIResource { }
    // MARK: Chat
    public final class ChatCompletionsSyncResource: OpenAISyncAPIResource { }
    public final class ChatsSyncResource: OpenAISyncAPIResource {
        public lazy var completions = ChatCompletionsSyncResource(clientOption)
    }
    // MARK: Embedding
    public final class EmbeddingsSyncResource: OpenAISyncAPIResource { }
    // MARK: Image
    public final class ImageGenerateSyncResource: OpenAISyncAPIResource { }
    public final class ImageEditSyncResource: OpenAISyncAPIResource { }
    public final class ImagesSyncResource: OpenAISyncAPIResource {
        public lazy var generate = ImageGenerateSyncResource(clientOption)
        public lazy var edit = ImageEditSyncResource(clientOption)
    }
    // MARK: Audio
    public final class AudioSpeechSyncResource: OpenAISyncAPIResource { }
    public final class AudioTranscriptionsSyncResource: OpenAISyncAPIResource { }
    public final class AudioSyncResource: OpenAISyncAPIResource {
        public lazy var speech = AudioSpeechSyncResource(clientOption)
        public lazy var transcriptions = AudioTranscriptionsSyncResource(clientOption)
    }
    // MARK: Response
    public final class ResponsesInputItemsSyncResource: OpenAISyncAPIResource { }
    public final class ResponsesInputTokensSyncResource: OpenAISyncAPIResource { }
    public final class ResponsesSyncResource: OpenAISyncAPIResource {
        public lazy var inputItems = ResponsesInputItemsSyncResource(clientOption)
        public lazy var inputTokens = ResponsesInputTokensSyncResource(clientOption)
    }
    // MARK: File
    public final class FilesSyncResource: OpenAISyncAPIResource { }
    
    // MARK: Upload
    public final class UploadsPartSyncResource: OpenAISyncAPIResource { }
    public final class UploadsSyncResource: OpenAISyncAPIResource {
        public lazy var part = UploadsPartSyncResource(clientOption)
    }

    // MARK: Video
    public final class VideosSyncResource: OpenAISyncAPIResource { }

    // MARK: Realtime
    public final class RealtimeSyncResource: OpenAISyncAPIResource { }
    
    
    // MARK: Beta
    public final class BetaRealtimeSyncResource: OpenAISyncAPIResource { }
    public final class BetaSyncResource: OpenAISyncAPIResource {
        public lazy var realtime = BetaRealtimeSyncResource(clientOption)
    }
}

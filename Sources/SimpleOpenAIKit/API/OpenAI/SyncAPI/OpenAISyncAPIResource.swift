//
//  OpenAISyncAPIResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/31/26.
//

public class OpenAISyncAPIResource {
    unowned let client: OpenAI

    init(_ client: OpenAI) {
        self.client = client
    }

    // MARK: Model
    public final class ModelsSyncResource: OpenAISyncAPIResource { }
    // MARK: Completions
    public final class CompletionsSyncResource: OpenAISyncAPIResource { }
    // MARK: Chat
    public final class ChatCompletionsSyncResource: OpenAISyncAPIResource { }
    public final class ChatsSyncResource: OpenAISyncAPIResource {
        public lazy var completions = ChatCompletionsSyncResource(client)
    }
    // MARK: Embedding
    public final class EmbeddingsSyncResource: OpenAISyncAPIResource { }
    // MARK: Image
    public final class ImageGenerateSyncResource: OpenAISyncAPIResource { }
    public final class ImageEditSyncResource: OpenAISyncAPIResource { }
    public final class ImagesSyncResource: OpenAISyncAPIResource {
        public lazy var generate = ImageGenerateSyncResource(client)
        public lazy var edit = ImageEditSyncResource(client)
    }
    // MARK: Audio
    public final class AudioSpeechSyncResource: OpenAISyncAPIResource { }
    public final class AudioTranscriptionsSyncResource: OpenAISyncAPIResource { }
    public final class AudioSyncResource: OpenAISyncAPIResource {
        public lazy var speech = AudioSpeechSyncResource(client)
        public lazy var transcriptions = AudioTranscriptionsSyncResource(client)
    }
    // MARK: Response
    public final class ResponsesInputItemsSyncResource: OpenAISyncAPIResource { }
    public final class ResponsesInputTokensSyncResource: OpenAISyncAPIResource { }
    public final class ResponsesSyncResource: OpenAISyncAPIResource {
        public lazy var inputItems = ResponsesInputItemsSyncResource(client)
        public lazy var inputTokens = ResponsesInputTokensSyncResource(client)
    }
    // MARK: File
    public final class FilesSyncResource: OpenAISyncAPIResource { }
    
    // MARK: Upload
    public final class UploadsPartSyncResource: OpenAISyncAPIResource { }
    public final class UploadsSyncResource: OpenAISyncAPIResource {
        public lazy var part = UploadsPartSyncResource(client)
    }

    // MARK: Video
    public final class VideosSyncResource: OpenAISyncAPIResource { }

    // MARK: Realtime
    public final class RealtimeSyncResource: OpenAISyncAPIResource { }
    
    
    // MARK: Beta
    public final class BetaRealtimeSyncResource: OpenAISyncAPIResource { }
    public final class BetaSyncResource: OpenAISyncAPIResource {
        public lazy var realtime = BetaRealtimeSyncResource(client)
    }
}

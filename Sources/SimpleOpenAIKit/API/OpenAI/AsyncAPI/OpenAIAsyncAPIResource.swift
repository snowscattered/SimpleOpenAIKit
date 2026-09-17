//
//  OpenAIAsyncAPIResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/8/26.
//

public class OpenAIAsyncAPIResource {
    let clientOption: OpenAIClientOption
    init(_ clientOption: OpenAIClientOption) {
        self.clientOption = clientOption
    }

    // MARK: Model
    public final class ModelsAsyncResource: OpenAIAsyncAPIResource { }
    // MARK: Completions
    public final class CompletionsAsyncResource: OpenAIAsyncAPIResource { }
    // MARK: Chat
    public final class ChatCompletionsAsyncResource: OpenAIAsyncAPIResource { }
    public final class ChatsAsyncResource: OpenAIAsyncAPIResource {
        public lazy var completions = ChatCompletionsAsyncResource(clientOption)
    }
    // MARK: Embedding
    public final class EmbeddingsAsyncResource: OpenAIAsyncAPIResource { }
    // MARK: Image
    public final class ImageGenerateAsyncResource: OpenAIAsyncAPIResource { }
    public final class ImageEditAsyncResource: OpenAIAsyncAPIResource { }
    public final class ImagesAsyncResource: OpenAIAsyncAPIResource {
        public lazy var generate = ImageGenerateAsyncResource(clientOption)
        public lazy var edit = ImageEditAsyncResource(clientOption)
    }
    // MARK: Audio
    public final class AudioSpeechAsyncResource: OpenAIAsyncAPIResource { }
    public final class AudioTranscriptionsAsyncResource: OpenAIAsyncAPIResource { }
    public final class AudioAsyncResource: OpenAIAsyncAPIResource {
        public lazy var speech = AudioSpeechAsyncResource(clientOption)
        public lazy var transcriptions = AudioTranscriptionsAsyncResource(clientOption)
    }
    // MARK: Response
    public final class ResponsesInputItemsAsyncResource: OpenAIAsyncAPIResource { }
    public final class ResponsesInputTokensAsyncResource: OpenAIAsyncAPIResource { }
    public final class ResponsesAsyncResource: OpenAIAsyncAPIResource {
        public lazy var inputItems = ResponsesInputItemsAsyncResource(clientOption)
        public lazy var inputTokens = ResponsesInputTokensAsyncResource(clientOption)
    }
    // MARK: File
    public final class FilesAsyncResource: OpenAIAsyncAPIResource { }
    
    // MARK: Upload
    public final class UploadsPartAsyncResource: OpenAIAsyncAPIResource { }
    public final class UploadsAsyncResource: OpenAIAsyncAPIResource {
        public lazy var part = UploadsPartAsyncResource(clientOption)
    }
    
    // MARK: Viideo
    public final class VideosAsyncResource: OpenAIAsyncAPIResource { }
    
    // MARK: Realtime
    public final class RealtimeAsyncResource: OpenAIAsyncAPIResource { }
    
    
    // MARK: Beta
    public final class BetaRealtimeAsyncResource: OpenAIAsyncAPIResource { }
    public final class BetaAsyncResource: OpenAIAsyncAPIResource {
        public lazy var realtime = BetaRealtimeAsyncResource(clientOption)
    }
}

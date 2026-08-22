//
//  OpenAIAsyncAPIResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/8/26.
//

public class OpenAIAsyncAPIResource {
    internal unowned let client: AsyncOpenAI

    internal init(_ client: AsyncOpenAI) {
        self.client = client
    }

    // MARK: Model
    public final class ModelsAsyncResource: OpenAIAsyncAPIResource { }
    // MARK: Completions
    public final class CompletionsAsyncResource: OpenAIAsyncAPIResource { }
    // MARK: Chat
    public final class ChatCompletionsAsyncResource: OpenAIAsyncAPIResource { }
    public final class ChatsAsyncResource: OpenAIAsyncAPIResource {
        public lazy var completions = ChatCompletionsAsyncResource(client)
    }
    // MARK: Embedding
    public final class EmbeddingsAsyncResource: OpenAIAsyncAPIResource { }
    // MARK: Image
    public final class ImageGenerateAsyncResource: OpenAIAsyncAPIResource { }
    public final class ImageEditAsyncResource: OpenAIAsyncAPIResource { }
    public final class ImagesAsyncResource: OpenAIAsyncAPIResource {
        public lazy var generate = ImageGenerateAsyncResource(client)
        public lazy var edit = ImageEditAsyncResource(client)
    }
    // MARK: Audio
    public final class AudioSpeechAsyncResource: OpenAIAsyncAPIResource { }
    public final class AudioTranscriptionsAsyncResource: OpenAIAsyncAPIResource { }
    public final class AudioAsyncResource: OpenAIAsyncAPIResource {
        public lazy var speech = AudioSpeechAsyncResource(client)
        public lazy var transcriptions = AudioTranscriptionsAsyncResource(client)
    }
    // MARK: Response
    public final class ResponsesInputItemsAsyncResource: OpenAIAsyncAPIResource { }
    public final class ResponsesInputTokensAsyncResource: OpenAIAsyncAPIResource { }
    public final class ResponsesAsyncResource: OpenAIAsyncAPIResource {
        public lazy var inputItems = ResponsesInputItemsAsyncResource(client)
        public lazy var inputTokens = ResponsesInputTokensAsyncResource(client)
    }
    // MARK: File
    public final class FilesAsyncResource: OpenAIAsyncAPIResource { }
    
    // MARK: Upload
    public final class UploadsPartAsyncResource: OpenAIAsyncAPIResource { }
    public final class UploadsAsyncResource: OpenAIAsyncAPIResource {
        public lazy var part = UploadsPartAsyncResource(client)
    }
    
    // MARK: Viideo
    public final class VideosAsyncResource: OpenAIAsyncAPIResource { }
    
    // MARK: Realtime
    public final class RealtimeAsyncResource: OpenAIAsyncAPIResource { }
    
    
    // MARK: Beta
    public final class BetaRealtimeAsyncResource: OpenAIAsyncAPIResource { }
    public final class BetaAsyncResource: OpenAIAsyncAPIResource {
        public lazy var realtime = BetaRealtimeAsyncResource(client)
    }
}

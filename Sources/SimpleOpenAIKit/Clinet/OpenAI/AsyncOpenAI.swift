//
//  AsyncOpenAI.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/8/26.
//

import Foundation

public final class AsyncOpenAI: OpenAIClient {
    // MARK: Resource namespaces
    public lazy var models = OpenAIAsyncAPIResource.ModelsAsyncResource(self)
    public lazy var completions = OpenAIAsyncAPIResource.CompletionsAsyncResource(self)
    public lazy var chat = OpenAIAsyncAPIResource.ChatsAsyncResource(self)
    public lazy var embeddings = OpenAIAsyncAPIResource.EmbeddingsAsyncResource(self)
    public lazy var images = OpenAIAsyncAPIResource.ImagesAsyncResource(self)
    public lazy var audio = OpenAIAsyncAPIResource.AudioAsyncResource(self)
    public lazy var responses = OpenAIAsyncAPIResource.ResponsesAsyncResource(self)
    public lazy var files = OpenAIAsyncAPIResource.FilesAsyncResource(self)
    public lazy var uploads = OpenAIAsyncAPIResource.UploadsAsyncResource(self)
    public lazy var videos = OpenAIAsyncAPIResource.VideosAsyncResource(self)
    public lazy var realtime = OpenAIAsyncAPIResource.RealtimeAsyncResource(self)
//    public lazy var vector_stores = VectorStoresAsyncResource(self)
//    public lazy var batches = BatchesAsyncResource(self)
//    public lazy var fine_tuning = FineTuningAsyncResource(self)
//    public lazy var containers = ContainersAsyncResource(self)
//    public lazy var skills = SkillsAsyncResource(self)
//    public lazy var moderations = ModerationsAsyncResource(self)
//    public lazy var webhooks = WebhooksAsyncResource(self)
//    public lazy var conversations = ConversationsAsyncResource(self)
//    public lazy var evals = EvalsAsyncResource(self)
    public lazy var beta = OpenAIAsyncAPIResource.BetaAsyncResource(self)
}

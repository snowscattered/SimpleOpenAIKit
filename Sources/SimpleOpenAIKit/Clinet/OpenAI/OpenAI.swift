//
//  OpenAI.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/20/26.
//

import Foundation

public final class OpenAI: OpenAIClient {
    // MARK: Resource namespaces
    public lazy var models = OpenAISyncAPIResource.ModelsSyncResource(self)
    public lazy var completions = OpenAISyncAPIResource.CompletionsSyncResource(self)
    public lazy var chat = OpenAISyncAPIResource.ChatsSyncResource(self)
    public lazy var embeddings = OpenAISyncAPIResource.EmbeddingsSyncResource(self)
    public lazy var images = OpenAISyncAPIResource.ImagesSyncResource(self)
    public lazy var audio = OpenAISyncAPIResource.AudioSyncResource(self)
    public lazy var responses = OpenAISyncAPIResource.ResponsesSyncResource(self)
    public lazy var files = OpenAISyncAPIResource.FilesSyncResource(self)
    public lazy var uploads = OpenAISyncAPIResource.UploadsSyncResource(self)
    public lazy var videos = OpenAISyncAPIResource.VideosSyncResource(self)
    public lazy var realtime = OpenAISyncAPIResource.RealtimeSyncResource(self)
//    public lazy var vector_stores = VectorStoresAsyncResource(self)
//    public lazy var batches = BatchesAsyncResource(self)
//    public lazy var fine_tuning = FineTuningAsyncResource(self)
//    public lazy var containers = ContainersAsyncResource(self)
//    public lazy var skills = SkillsAsyncResource(self)
//    public lazy var moderations = ModerationsAsyncResource(self)
//    public lazy var webhooks = WebhooksAsyncResource(self)
//    public lazy var conversations = ConversationsAsyncResource(self)
//    public lazy var evals = EvalsAsyncResource(self)
    public lazy var beta = OpenAISyncAPIResource.BetaSyncResource(self)
}

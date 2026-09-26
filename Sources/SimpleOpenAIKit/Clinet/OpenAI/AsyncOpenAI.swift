//
//  AsyncOpenAI.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/8/26.
//

import Foundation

public class AsyncOpenAI {
    private let clientOption: OpenAIClientOption
    public var api_key: String { clientOption.api_key }
    public var organization: String? { clientOption.organization }
    public var project: String? { clientOption.project }
    public var webhook_secret: String? { clientOption.webhook_secret }

    public var base_url: URL { clientOption.base_url }
    public var websocket_base_url: URL { clientOption.websocket_base_url }

    public var timeout: TimeInterval { clientOption.timeout }
    public var max_retries: Int { clientOption.max_retries }
    public var headers: Header { clientOption.headers }
    public var query: Query { clientOption.query }
    
    
    // MARK: Resource namespaces
    public let models: OpenAIAsyncAPIResource.ModelsAsyncResource
    public let completions: OpenAIAsyncAPIResource.CompletionsAsyncResource
    public let chat: OpenAIAsyncAPIResource.ChatsAsyncResource
    public let embeddings: OpenAIAsyncAPIResource.EmbeddingsAsyncResource
    public let images: OpenAIAsyncAPIResource.ImagesAsyncResource
    public let audio: OpenAIAsyncAPIResource.AudioAsyncResource
    public let responses: OpenAIAsyncAPIResource.ResponsesAsyncResource
    public let files: OpenAIAsyncAPIResource.FilesAsyncResource
    public let uploads: OpenAIAsyncAPIResource.UploadsAsyncResource
    public let videos: OpenAIAsyncAPIResource.VideosAsyncResource
    public let realtime: OpenAIAsyncAPIResource.RealtimeAsyncResource
//    public let vector_stores: OpenAIAsyncAPIResource.VectorStoresAsyncResource
//    public let batches: OpenAIAsyncAPIResource.BatchesAsyncResource
//    public let fine_tuning: OpenAIAsyncAPIResource.FineTuningAsyncResource
//    public let containers: OpenAIAsyncAPIResource.ContainersAsyncResource
//    public let skills: OpenAIAsyncAPIResource.SkillsAsyncResource
//    public let moderations: OpenAIAsyncAPIResource.ModerationsAsyncResource
//    public let webhooks: OpenAIAsyncAPIResource.WebhooksAsyncResource
//    public let conversations: OpenAIAsyncAPIResource.ConversationsAsyncResource
//    public let evals: OpenAIAsyncAPIResource.EvalsSyncResource
    public let beta: OpenAIAsyncAPIResource.BetaAsyncResource
    
    public init(
        api_key: String,
        organization: String? = nil,
        project: String? = nil,
        webhook_secret: String? = nil,
        base_url: URL = URL(string: "https://api.openai.com/v1")!,
        
        websocket_base_url: URL = URL(string: "wss://api.openai.com/v1")!,
        timeout: TimeInterval = 600,
        max_retries: Int = 2,
        
        default_headers: Header = [:],
        default_query: Query = [:]
    ) {
        let clientOption: OpenAIClientOption = .init(
            api_key: api_key,
            organization: organization,
            project: project,
            webhook_secret: webhook_secret,
            
            base_url: base_url,
            websocket_base_url: websocket_base_url,
            
            timeout: timeout,
            max_retries: max_retries,
            
            default_headers: default_headers,
            default_query: default_query
        )
        self.models      = .init(clientOption)
        self.completions = .init(clientOption)
        self.chat        = .init(clientOption)
        self.embeddings  = .init(clientOption)
        self.images      = .init(clientOption)
        self.audio       = .init(clientOption)
        self.responses   = .init(clientOption)
        self.files       = .init(clientOption)
        self.uploads     = .init(clientOption)
        self.videos      = .init(clientOption)
        self.realtime    = .init(clientOption)
        self.beta        = .init(clientOption)
        self.clientOption = clientOption
    }
}

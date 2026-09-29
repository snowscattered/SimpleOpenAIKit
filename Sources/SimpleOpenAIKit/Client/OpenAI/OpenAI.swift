//
//  OpenAI.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/20/26.
//

import Foundation

public class OpenAI {
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
    public let models: OpenAISyncAPIResource.ModelsSyncResource
    public let completions: OpenAISyncAPIResource.CompletionsSyncResource
    public let chat: OpenAISyncAPIResource.ChatsSyncResource
    public let embeddings: OpenAISyncAPIResource.EmbeddingsSyncResource
    public let images: OpenAISyncAPIResource.ImagesSyncResource
    public let audio: OpenAISyncAPIResource.AudioSyncResource
    public let responses: OpenAISyncAPIResource.ResponsesSyncResource
    public let files: OpenAISyncAPIResource.FilesSyncResource
    public let uploads: OpenAISyncAPIResource.UploadsSyncResource
    public let videos: OpenAISyncAPIResource.VideosSyncResource
    public let realtime: OpenAISyncAPIResource.RealtimeSyncResource
//    public let vector_stores: OpenAISyncAPIResource.VectorStoresSyncResource
//    public let batches: OpenAISyncAPIResource.BatchesSyncResource
//    public let fine_tuning: OpenAISyncAPIResource.FineTuningSyncResource
//    public let containers: OpenAISyncAPIResource.ContainersSyncResource
//    public let skills: OpenAISyncAPIResource.SkillsSyncResource
//    public let moderations: OpenAISyncAPIResource.ModerationsSyncResource
//    public let webhooks: OpenAISyncAPIResource.WebhooksSyncResource
//    public let conversations: OpenAISyncAPIResource.ConversationsSyncResource
//    public let evals: OpenAISyncAPIResource.EvalsSyncResource
    public let beta: OpenAISyncAPIResource.BetaSyncResource

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

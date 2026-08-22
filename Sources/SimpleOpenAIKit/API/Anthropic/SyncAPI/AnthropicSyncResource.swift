//
//  AnthropicSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

public class AnthropicSyncAPIResource {
    internal unowned let client: Anthropic

    internal init(_ client: Anthropic) {
        self.client = client
    }
    // MARK: Model
    public final class ModelsSyncResource: AnthropicSyncAPIResource { }
    // MARK: Completions
    public final class CompletionsSyncResource: AnthropicSyncAPIResource { }
    // MARK: Message
    public final class MessagesSyncResource: AnthropicSyncAPIResource { }
}

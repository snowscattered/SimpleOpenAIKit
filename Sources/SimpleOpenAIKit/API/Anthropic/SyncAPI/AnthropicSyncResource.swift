//
//  AnthropicSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

/// Namespaces of the blocking Anthropic client.
public enum AnthropicSyncAPIResource {
    // MARK: Model
    /// `/v1/models`: page through and inspect the available models.
    public struct ModelsSyncResource: ~Copyable, ResourceProtocol {
        let clientOption: AnthropicClientOption
        init(_ clientOption: AnthropicClientOption) { self.clientOption = clientOption }
    }

    // MARK: Completions
    /// `/v1/complete`: legacy text completions, plus its streaming variant.
    public struct CompletionsSyncResource: ~Copyable, ResourceProtocol {
        let clientOption: AnthropicClientOption
        init(_ clientOption: AnthropicClientOption) { self.clientOption = clientOption }
    }

    // MARK: Message
    /// `/v1/messages`: chat requests, streamed events and token counting.
    public struct MessagesSyncResource: ~Copyable, ResourceProtocol {
        let clientOption: AnthropicClientOption
        init(_ clientOption: AnthropicClientOption) { self.clientOption = clientOption }
    }
}

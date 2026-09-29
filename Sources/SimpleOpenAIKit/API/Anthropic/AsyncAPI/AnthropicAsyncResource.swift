//
//  AnthropicAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

/// Namespaces of the awaitable Anthropic client.
public enum AnthropicAsyncAPIResource {
    // MARK: Model
    /// `/v1/models`: page through and inspect the available models.
    public struct ModelsAsyncResource: ~Copyable {
        let clientOption: AnthropicClientOption
        init(_ clientOption: AnthropicClientOption) { self.clientOption = clientOption }
    }

    // MARK: Completions
    /// `/v1/complete`: legacy text completions, plus its streaming variant.
    public struct CompletionsAsyncResource: ~Copyable {
        let clientOption: AnthropicClientOption
        init(_ clientOption: AnthropicClientOption) { self.clientOption = clientOption }
    }

    // MARK: Message
    /// `/v1/messages`: chat requests, streamed events and token counting.
    public struct MessagesAsyncResource: ~Copyable {
        let clientOption: AnthropicClientOption
        init(_ clientOption: AnthropicClientOption) { self.clientOption = clientOption }
    }
}

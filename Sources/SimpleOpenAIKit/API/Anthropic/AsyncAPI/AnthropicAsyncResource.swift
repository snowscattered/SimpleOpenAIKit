//
//  AnthropicAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

public enum AnthropicAsyncAPIResource {
    // MARK: Model
    public struct ModelsAsyncResource: ~Copyable {
        let clientOption: AnthropicClientOption
        init(_ clientOption: AnthropicClientOption) { self.clientOption = clientOption }
    }

    // MARK: Completions
    public struct CompletionsAsyncResource: ~Copyable {
        let clientOption: AnthropicClientOption
        init(_ clientOption: AnthropicClientOption) { self.clientOption = clientOption }
    }

    // MARK: Message
    public struct MessagesAsyncResource: ~Copyable {
        let clientOption: AnthropicClientOption
        init(_ clientOption: AnthropicClientOption) { self.clientOption = clientOption }
    }
}

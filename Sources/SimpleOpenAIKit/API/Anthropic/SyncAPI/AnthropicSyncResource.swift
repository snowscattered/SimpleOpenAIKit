//
//  AnthropicSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

public enum AnthropicSyncAPIResource {
    // MARK: Model
    public struct ModelsSyncResource: ~Copyable {
        let clientOption: AnthropicClientOption
        init(_ clientOption: AnthropicClientOption) { self.clientOption = clientOption }
    }

    // MARK: Completions
    public struct CompletionsSyncResource: ~Copyable {
        let clientOption: AnthropicClientOption
        init(_ clientOption: AnthropicClientOption) { self.clientOption = clientOption }
    }

    // MARK: Message
    public struct MessagesSyncResource: ~Copyable {
        let clientOption: AnthropicClientOption
        init(_ clientOption: AnthropicClientOption) { self.clientOption = clientOption }
    }
}

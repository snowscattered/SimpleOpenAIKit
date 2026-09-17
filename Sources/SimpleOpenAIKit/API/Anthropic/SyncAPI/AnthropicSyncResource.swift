//
//  AnthropicSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

public class AnthropicSyncAPIResource {
    let clientOption: AnthropicClientOption
    init(_ clientOption: AnthropicClientOption) {
        self.clientOption = clientOption
    }
    // MARK: Model
    public final class ModelsSyncResource: AnthropicSyncAPIResource { }
    // MARK: Completions
    public final class CompletionsSyncResource: AnthropicSyncAPIResource { }
    // MARK: Message
    public final class MessagesSyncResource: AnthropicSyncAPIResource { }
}

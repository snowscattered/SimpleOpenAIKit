//
//  AnthropicAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

public class AnthropicAsyncAPIResource {
    let clientOption: AnthropicClientOption
    init(_ clientOption: AnthropicClientOption) {
        self.clientOption = clientOption
    }
    // MARK: Model
    public final class ModelsAsyncResource: AnthropicAsyncAPIResource { }
    // MARK: Completions
    public final class CompletionsAsyncResource: AnthropicAsyncAPIResource { }
    // MARK: Message
    public final class MessagesAsyncResource: AnthropicAsyncAPIResource { }
}

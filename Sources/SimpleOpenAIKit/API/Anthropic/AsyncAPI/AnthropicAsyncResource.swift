//
//  AnthropicAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

public class AnthropicAsyncAPIResource {
    internal unowned let client: AsyncAnthropic

    internal init(_ client: AsyncAnthropic) {
        self.client = client
    }
    // MARK: Model
    public final class ModelsAsyncResource: AnthropicAsyncAPIResource { }
    // MARK: Completions
    public final class CompletionsAsyncResource: AnthropicAsyncAPIResource { }
    // MARK: Message
    public final class MessagesAsyncResource: AnthropicAsyncAPIResource { }
}

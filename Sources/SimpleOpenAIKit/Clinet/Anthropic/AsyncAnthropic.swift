//
//  AsyncAnthropic.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public final class AsyncAnthropic: AnthropicClient {
    // MARK: Resource namespaces
    public lazy var models = AnthropicAsyncAPIResource.ModelsAsyncResource(self)
    public lazy var completions = AnthropicAsyncAPIResource.CompletionsAsyncResource(self)
    public lazy var messages = AnthropicAsyncAPIResource.MessagesAsyncResource(self)
}

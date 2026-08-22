//
//  Anthropic.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public final class Anthropic: AnthropicClient {
    // MARK: Resource namespaces
    public lazy var models = AnthropicSyncAPIResource.ModelsSyncResource(self)
    public lazy var completions = AnthropicSyncAPIResource.CompletionsSyncResource(self)
    public lazy var messages = AnthropicSyncAPIResource.MessagesSyncResource(self)
}

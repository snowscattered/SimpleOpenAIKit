//
//  ResponseCompactParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/21/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelWithExtra
public struct ResponseCompactParameters {
    public var model: String?
    public var input: ResponseInputOrItems?
    public var instructions: String?
    public var previous_response_id: String?
    public var prompt_cache_key: String?
    public var prompt_cache_options: ResponsePromptCacheOption?
    public var prompt_cache_retention: ResponsePromptCacheRetentionLiteral?
    public var service_tier: ResponseServiceTierLiteral?
}

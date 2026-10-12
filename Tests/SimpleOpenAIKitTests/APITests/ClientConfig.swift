//
//  ClientConfig.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//
import Testing
import Foundation
@testable import SimpleOpenAIKit

let client = OpenAI(
    api_key: "NoKey",
    base_url: URL(string: "https://localhost:8000")!,
    max_retries: 1
)
let asyncClient = AsyncOpenAI(
    api_key: client.api_key,
    base_url: client.base_url,
    max_retries: 1
)

let anthropicClient = Anthropic(
    api_key: "NoKey",
    base_url: URL(string: "https://localhost:8000")!,
    max_retries: 1
)
let anthropicAsyncClient = AsyncAnthropic(
    api_key: anthropicClient.api_key,
    base_url: anthropicClient.base_url,
    max_retries: 1
)

let typeSafeClient = TypeSafeClient(
    api_key: "NoKey",
    base_url: URL(string: "https://api.typesafe.ai")!,
    max_retries: 1
)
let asyncTypeSafeClient = AsyncTypeSafeClient(
    api_key: typeSafeClient.api_key,
    base_url: typeSafeClient.base_url,
    max_retries: 1
)
let bundle = Bundle.module

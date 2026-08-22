//
//  ImagesAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public extension OpenAIAsyncAPIResource.ImagesAsyncResource {
    func generate(
        parameters: ImageGenerateParameters,
        requestOptions: RequestOptions? = nil
    ) async throws -> ImageGenerateResult {
        let url = try client.getServerUrl(path: "/images/generations")
        var nostreamingParameters = parameters
        nostreamingParameters.stream = false
        return try await OpenAISession.shared.AsyncResponse(
            url,
            payload: nostreamingParameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post
        )
    }

    func generateStream(
        parameters: ImageGenerateParameters,
        requestOptions: RequestOptions? = nil
    ) async throws -> AsyncThrowingStream<ImagesGenerateStreamResult, Error> {
        let url = try client.getServerUrl(path: "/images/generations")
        var streamingParameters = parameters
        streamingParameters.stream = true
        return try await OpenAISession.shared.AsyncStreamResponse(
            url,
            payload: streamingParameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post
        )
    }

    func edit(
        parameters: ImageEditParameters,
        requestOptions: RequestOptions? = nil
    ) async throws -> ImageEditResult {
        let url = try client.getServerUrl(path: "/images/edits")
        var nostreamingParameters = parameters
        nostreamingParameters.stream = false
        return try await OpenAISession.shared.AsyncResponse(
            url,
            payload: nostreamingParameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post
        )
    }

    func editStream(
        parameters: ImageEditParameters,
        requestOptions: RequestOptions? = nil
    ) async throws -> AsyncThrowingStream<ImagesEditStreamResult, Error> {
        let url = try client.getServerUrl(path: "/images/edits")
        var streamingParameters = parameters
        streamingParameters.stream = true
        return try await OpenAISession.shared.AsyncStreamResponse(
            url,
            payload: streamingParameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post
        )
    }
}

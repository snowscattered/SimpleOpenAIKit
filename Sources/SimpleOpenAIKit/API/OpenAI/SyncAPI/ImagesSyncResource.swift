//
//  ImagesSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public extension OpenAISyncAPIResource.ImagesSyncResource {
    /// Generate images from a prompt.
    func generate(
        parameters: ImageGenerateParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> ImageGenerateResult {
        let url = try clientOption.getServerUrl(path: "/images/generations")
        var nostreamingParameters = parameters
        nostreamingParameters.stream = false
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: nostreamingParameters,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .post
        )
    }
    /// Generate images and iterate the partial results.
    func generateStream(
        parameters: ImageGenerateParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> SyncThrowingStream<ImagesGenerateStreamResult, any Error> {
        let url = try clientOption.getServerUrl(path: "/images/generations")
        var streamingParameters = parameters
        streamingParameters.stream = true
        return try OpenAISession.shared.SyncStreamResponse(
            url,
            payload: streamingParameters,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .post
        )
    }
    
    /// Edit or vary existing images; the body is sent as multipart form data.
    func edit(
        parameters: ImageEditParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> ImageEditResult {
        let url = try clientOption.getServerUrl(path: "/images/edits")
        var nostreamingParameters = parameters
        nostreamingParameters.stream = false
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: nostreamingParameters,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .post
        )
    }
    /// Edit or vary existing images and iterate the partial results.
    func editStream(
        parameters: ImageEditParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> SyncThrowingStream<ImagesEditStreamResult, any Error> {
        let url = try clientOption.getServerUrl(path: "/images/edits")
        var streamingParameters = parameters
        streamingParameters.stream = true
        return try OpenAISession.shared.SyncStreamResponse(
            url,
            payload: streamingParameters,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .post
        )
    }
}

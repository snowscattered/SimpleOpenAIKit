//
//  ImagesSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public extension OpenAISyncAPIResource.ImagesSyncResource {
    func generate(
        parameters: ImageGenerateParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> ImageGenerateResult {
        let url = try client.getServerUrl(path: "/images/generations")
        var nostreamingParameters = parameters
        nostreamingParameters.stream = false
        return try OpenAISession.shared.SyncResponse(
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
    ) throws -> SyncThrowingStream<ImagesGenerateStreamResult, Error> {
        let url = try client.getServerUrl(path: "/images/generations")
        var streamingParameters = parameters
        streamingParameters.stream = true
        return try OpenAISession.shared.SyncStreamResponse(
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
    ) throws -> ImageEditResult {
        let url = try client.getServerUrl(path: "/images/edits")
        var nostreamingParameters = parameters
        nostreamingParameters.stream = false
        return try OpenAISession.shared.SyncResponse(
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
    ) throws -> SyncThrowingStream<ImagesEditStreamResult, Error> {
        let url = try client.getServerUrl(path: "/images/edits")
        var streamingParameters = parameters
        streamingParameters.stream = true
        return try OpenAISession.shared.SyncStreamResponse(
            url,
            payload: streamingParameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post
        )
    }
}

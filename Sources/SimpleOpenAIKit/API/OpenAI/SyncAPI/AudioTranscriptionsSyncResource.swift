//
//  AudioTranscriptionsSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public extension OpenAISyncAPIResource.AudioTranscriptionsSyncResource {
    func create(
        parameters: AudioTranscriptionParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> AudioTranscriptionCreateResult {
        let url = try client.getServerUrl(path: "/audio/transcriptions")
        var nostreamingParameters = parameters
        nostreamingParameters.stream = false
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: nostreamingParameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post,
            hasFile: true,
        )
    }
    func stream(
        parameters: AudioTranscriptionParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> SyncThrowingStream<AudioTranscriptionStreamResult, Error> {
        let url = try client.getServerUrl(path: "/audio/transcriptions")
        var streamingParameters = parameters
        streamingParameters.stream = true
        return try OpenAISession.shared.SyncStreamResponse(
            url,
            payload: streamingParameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post,
            hasFile: true,
        )
    }
}

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
        let url = try clientOption.getServerUrl(path: "/audio/transcriptions")
        var nostreamingParameters = parameters
        nostreamingParameters.stream = false
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: nostreamingParameters,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .post,
            hasFile: true,
        )
    }
    func stream(
        parameters: AudioTranscriptionParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> SyncThrowingStream<AudioTranscriptionStreamResult, Error> {
        let url = try clientOption.getServerUrl(path: "/audio/transcriptions")
        var streamingParameters = parameters
        streamingParameters.stream = true
        return try OpenAISession.shared.SyncStreamResponse(
            url,
            payload: streamingParameters,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .post,
            hasFile: true,
        )
    }
}

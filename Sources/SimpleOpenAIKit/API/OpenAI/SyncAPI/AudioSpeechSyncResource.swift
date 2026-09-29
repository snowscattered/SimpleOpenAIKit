//
//  AudioSpeechSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public extension OpenAISyncAPIResource.AudioSpeechSyncResource {
    /// Synthesize speech and return the complete audio payload.
    func create(
        parameters: AudioSpeechParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> Data {
        let url = try clientOption.getServerUrl(path: "/audio/speech")
        var options = requestOptions ?? RequestOptions()
        if options.extra_headers["Accept"] == nil {
            options.extra_headers["Accept"] = "application/octet-stream"
        }
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: parameters,
            requestOptions: options,
            clientOption: self.clientOption,
            method: .post
        )
    }
    
    /// Synthesize speech and iterate raw audio chunks as they arrive.
    func stream(
        parameters: AudioSpeechParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> SyncThrowingStream<Data, any Error> {
        let url = try clientOption.getServerUrl(path: "/audio/speech")
        var options = requestOptions ?? RequestOptions()
        if options.extra_headers["Accept"] == nil {
            options.extra_headers["Accept"] = "application/octet-stream"
        }
        return try OpenAISession.shared.SyncStreamResponse(
            url,
            payload: parameters,
            requestOptions: options,
            clientOption: self.clientOption,
            method: .post
        )
    }
}

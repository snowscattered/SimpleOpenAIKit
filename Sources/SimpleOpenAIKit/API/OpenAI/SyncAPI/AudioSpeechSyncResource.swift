//
//  AudioSpeechSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public extension OpenAISyncAPIResource.AudioSpeechSyncResource {
    func create(
        parameters: AudioSpeechParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> Data {
        let url = try client.getServerUrl(path: "/audio/speech")
        var options = requestOptions ?? RequestOptions()
        if options.extra_headers["Accept"] == nil {
            options.extra_headers["Accept"] = "application/octet-stream"
        }
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: parameters,
            requestOptions: options,
            client: self.client,
            method: .post
        )
    }
    
    func stream(
        parameters: AudioSpeechParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> SyncThrowingStream<Data, Error> {
        let url = try client.getServerUrl(path: "/audio/speech")
        var options = requestOptions ?? RequestOptions()
        if options.extra_headers["Accept"] == nil {
            options.extra_headers["Accept"] = "application/octet-stream"
        }
        return try OpenAISession.shared.SyncStreamResponse(
            url,
            payload: parameters,
            requestOptions: options,
            client: self.client,
            method: .post
        )
    }
}

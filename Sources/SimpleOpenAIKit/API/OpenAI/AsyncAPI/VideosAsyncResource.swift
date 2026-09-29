//
//  VideosAsyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/11/26.
//

import Foundation

public extension OpenAIAsyncAPIResource.VideosAsyncResource {
    /// Start a video generation job.
    func create(
        parameters: VideoCreateParamerters,
        requestOptions: RequestOptions? = nil
    ) async throws -> VideoResult {
        let url = try clientOption.getServerUrl(path: "/videos")
        return try await OpenAISession.shared.AsyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .post,
            hasFile: true
        )
    }
    /// Iterate the videos under the account, one page per request.
    func list(
        parameters: VideoListParameter? = nil,
        requestOptions: RequestOptions? = nil
    ) async throws -> AsyncThrowingPages<VideoResult> {
        let url = try clientOption.getServerUrl(path: "/videos")
        var currentParams = parameters ?? VideoListParameter()
        var nextAfter = parameters?.after
        return AsyncThrowingPages { [clientOption] in
            currentParams.after = nextAfter
            let result: PageStruct<VideoResult> = try await OpenAISession.shared.AsyncResponse(
                url,
                payload: currentParams,
                requestOptions: requestOptions,
                clientOption: clientOption,
                method: .get
            )
            if let last = result.data.last {
                nextAfter = last.id
            }
            return result
        }
    }
    /// Fetch one video's status and metadata.
    func retrieve(
        video_id: String,
        requestOptions: RequestOptions? = nil
    ) async throws -> VideoResult {
        let url = try clientOption.getServerUrl(path: "/videos/\(video_id)")
        return try await OpenAISession.shared.AsyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .get
        )
    }
    /// Delete a video.
    func delete(
        video_id: String,
        requestOptions: RequestOptions? = nil
    ) async throws -> VideoDeleteResult {
        let url = try clientOption.getServerUrl(path: "/videos/\(video_id)")
        return try await OpenAISession.shared.AsyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .delete
        )
    }
    /// Rework an existing video.
    func edit(
        parameters: VideoEditParameter,
        requestOptions: RequestOptions? = nil
    ) async throws -> VideoResult {
        let url = try clientOption.getServerUrl(path: "/videos/edits")
        return try await OpenAISession.shared.AsyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .post,
            hasFile: true
        )
    }
    /// Append generated footage to an existing video.
    func extend(
        parameters: VideoExtendParameter,
        requestOptions: RequestOptions? = nil
    ) async throws -> VideoResult {
        let url = try clientOption.getServerUrl(path: "/videos/extend")
        return try await OpenAISession.shared.AsyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .post,
            hasFile: true
        )
    }
    /// Remix a video from a prompt.
    func remix(
        video_id: String,
        prompt: String,
        requestOptions: RequestOptions? = nil
    ) async throws -> VideoResult {
        let url = try clientOption.getServerUrl(path: "/videos/\(video_id)")
        let parameters = VideoRemixParameter(video_id: video_id, prompt: prompt)
        return try await OpenAISession.shared.AsyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .delete
        )
    }
    // MARK: Character
    /// Register a reusable character for later generations.
    func create_character(
        parameters: VideoCharacterCreateParameter,
        requestOptions: RequestOptions? = nil
    ) async throws -> VideoCharacterResult {
        let url = try clientOption.getServerUrl(path: "/videos/characters")
        return try await OpenAISession.shared.AsyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .post
        )
    }
    /// Fetch one character.
    func get_character(
        character_id: String,
        requestOptions: RequestOptions? = nil
    ) async throws -> VideoCharacterResult {
        let url = try clientOption.getServerUrl(path: "/videos/characters/\(character_id)")
        return try await OpenAISession.shared.AsyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            clientOption: self.clientOption,
            method: .get
        )
    }
    // MARK: Task
    /// Poll a video until it reaches a terminal status.
    func poll(
        video_id: String,
        poll_interval_ms: Int?,
    ) async throws -> VideoResult {
        var header: Header = ["X-Stainless-Poll-Helper": "true"]
        if let poll_interval_ms {
            header["X-Stainless-Custom-Poll-Interval"] = poll_interval_ms.description
        }
        while true {
            let video = try await self.retrieve(
                video_id: video_id,
                requestOptions: .init(extra_headers: header)
            )
            if video.status == .in_progress || video.status == .queued {
                if poll_interval_ms == nil {
                    try await Task.sleep(seconds: 1)
                } else {
                    return video
                }
            }
        }
    }
    /// Start a generation and poll it to completion in one call.
    func create_and_poll(
        parameters: VideoCreateParamerters,
        poll_interval_ms: Int?,
        requestOptions: RequestOptions? = nil
    ) async throws -> VideoResult {
        let video = try await self.create(
            parameters: parameters,
            requestOptions: requestOptions
        )
        return try await self.poll(video_id: video.id, poll_interval_ms: poll_interval_ms)
    }
    // MARK: Download
    /// Stream the finished video bytes.
    func download_content(
        video_id: String,
        variant: VideoDownloadContentVariant?,
        requestOptions: RequestOptions? = nil
    ) async throws -> AsyncThrowingStream<Data, any Error> {
        let url = try clientOption.getServerUrl(path: "/videos/\(video_id)/content")
        let parameters: VideoDownloadContentParameter = .init(video_id: video_id, variant: variant)
        var options = requestOptions ?? RequestOptions()
        if options.extra_headers["Accept"] == nil {
            options.extra_headers["Accept"] = "application/binary"
        }
        return try await OpenAISession.shared.AsyncStreamResponse(
            url,
            payload: parameters,
            requestOptions: options,
            clientOption: self.clientOption,
            method: .get
        )
    }
}

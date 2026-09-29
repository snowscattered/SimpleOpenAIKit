//
//  VideosSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/11/26.
//

import Foundation

public extension OpenAISyncAPIResource.VideosSyncResource {
    /// Start a video generation job.
    func create(
        parameters: VideoCreateParamerters,
        requestOptions: RequestOptions? = nil
    ) throws -> VideoResult {
        let url = try clientOption.getServerUrl(path: "/videos")
        return try OpenAISession.shared.SyncResponse(
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
    ) throws -> SyncThrowingPages<VideoResult> {
        let url = try clientOption.getServerUrl(path: "/videos")
        var nextAfter = parameters?.after
        return SyncThrowingPages { [clientOption] in
            var currentParams = parameters ?? VideoListParameter()
            currentParams.after = nextAfter
            
            let result: PageStruct<VideoResult> = try OpenAISession.shared.SyncResponse(
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
    ) throws -> VideoResult {
        let url = try clientOption.getServerUrl(path: "/videos/\(video_id)")
        return try OpenAISession.shared.SyncResponse(
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
    ) throws -> VideoDeleteResult {
        let url = try clientOption.getServerUrl(path: "/videos/\(video_id)")
        return try OpenAISession.shared.SyncResponse(
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
    ) throws -> VideoResult {
        let url = try clientOption.getServerUrl(path: "/videos/edits")
        return try OpenAISession.shared.SyncResponse(
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
    ) throws -> VideoResult {
        let url = try clientOption.getServerUrl(path: "/videos/extend")
        return try OpenAISession.shared.SyncResponse(
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
    ) throws -> VideoResult {
        let url = try clientOption.getServerUrl(path: "/videos/\(video_id)")
        let parameters = VideoRemixParameter(video_id: video_id, prompt: prompt)
        return try OpenAISession.shared.SyncResponse(
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
    ) throws -> VideoCharacterResult {
        let url = try clientOption.getServerUrl(path: "/videos/characters")
        return try OpenAISession.shared.SyncResponse(
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
    ) throws -> VideoCharacterResult {
        let url = try clientOption.getServerUrl(path: "/videos/characters/\(character_id)")
        return try OpenAISession.shared.SyncResponse(
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
    ) throws -> VideoResult {
        var header: Header = ["X-Stainless-Poll-Helper": "true"]
        if let poll_interval_ms {
            header["X-Stainless-Custom-Poll-Interval"] = poll_interval_ms.description
        }
        while true {
            let video = try self.retrieve(
                video_id: video_id,
                requestOptions: .init(extra_headers: header)
            )
            if video.status == .in_progress || video.status == .queued {
                if poll_interval_ms == nil {
                    Thread.sleep(forTimeInterval: 1)
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
    ) throws -> VideoResult {
        let video = try self.create(
            parameters: parameters,
            requestOptions: requestOptions
        )
        return try self.poll(video_id: video.id, poll_interval_ms: poll_interval_ms)
    }
    // MARK: Download
    /// Stream the finished video bytes.
    func download_content(
        video_id: String,
        variant: VideoDownloadContentVariant?,
        requestOptions: RequestOptions? = nil
    ) throws -> SyncThrowingStream<Data, any Error> {
        let url = try clientOption.getServerUrl(path: "/videos/\(video_id)/content")
        let parameters: VideoDownloadContentParameter = .init(video_id: video_id, variant: variant)
        var options = requestOptions ?? RequestOptions()
        if options.extra_headers["Accept"] == nil {
            options.extra_headers["Accept"] = "application/binary"
        }
        return try OpenAISession.shared.SyncStreamResponse(
            url,
            payload: parameters,
            requestOptions: options,
            clientOption: self.clientOption,
            method: .get
        )
    }
}

//
//  VideosSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/11/26.
//

import Foundation

public extension OpenAISyncAPIResource.VideosSyncResource {
    func create(
        parameters: VideoCreateParamerters,
        requestOptions: RequestOptions? = nil
    ) throws -> VideoResult {
        let url = try client.getServerUrl(path: "/videos")
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post,
            hasFile: true
        )
    }
    func list(
        parameters: VideoListParameter? = nil,
        requestOptions: RequestOptions? = nil
    ) throws -> SyncThrowingPages<VideoResult> {
        let url = try client.getServerUrl(path: "/videos")
        var nextAfter = parameters?.after
        return SyncThrowingPages {
            var currentParams = parameters ?? VideoListParameter()
            currentParams.after = nextAfter
            
            let result: PageStruct<VideoResult> = try OpenAISession.shared.SyncResponse(
                url,
                payload: currentParams,
                requestOptions: requestOptions,
                client: self.client,
                method: .get
            )
            if let last = result.data.last {
                nextAfter = last.id
            }
            return result
        }
    }
    func retrieve(
        video_id: String,
        requestOptions: RequestOptions? = nil
    ) throws -> VideoResult {
        let url = try client.getServerUrl(path: "/videos/\(video_id)")
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            client: self.client,
            method: .get
        )
    }
    func delete(
        video_id: String,
        requestOptions: RequestOptions? = nil
    ) throws -> VideoDeleteResult {
        let url = try client.getServerUrl(path: "/videos/\(video_id)")
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            client: self.client,
            method: .delete
        )
    }
    func edit(
        parameters: VideoEditParameter,
        requestOptions: RequestOptions? = nil
    ) throws -> VideoResult {
        let url = try client.getServerUrl(path: "/videos/edits")
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post,
            hasFile: true
        )
    }
    func extend(
        parameters: VideoExtendParameter,
        requestOptions: RequestOptions? = nil
    ) throws -> VideoResult {
        let url = try client.getServerUrl(path: "/videos/extend")
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post,
            hasFile: true
        )
    }
    func remix(
        video_id: String,
        prompt: String,
        requestOptions: RequestOptions? = nil
    ) throws -> VideoResult {
        let url = try client.getServerUrl(path: "/videos/\(video_id)")
        let parameters = VideoRemixParameter(video_id: video_id, prompt: prompt)
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .delete
        )
    }
    // MARK: Character
    func create_character(
        parameters: VideoCharacterCreateParameter,
        requestOptions: RequestOptions? = nil
    ) throws -> VideoCharacterResult {
        let url = try client.getServerUrl(path: "/videos/characters")
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post
        )
    }
    func get_character(
        character_id: String,
        requestOptions: RequestOptions? = nil
    ) throws -> VideoCharacterResult {
        let url = try client.getServerUrl(path: "/videos/characters/\(character_id)")
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            client: self.client,
            method: .get
        )
    }
    // MARK: Task
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
    func download_content(
        video_id: String,
        variant: VideoDownloadContentVariant?,
        requestOptions: RequestOptions? = nil
    ) throws -> SyncThrowingStream<Data, Error> {
        let url = try client.getServerUrl(path: "/videos/\(video_id)/content")
        let parameters: VideoDownloadContentParameter = .init(video_id: video_id, variant: variant)
        var options = requestOptions ?? RequestOptions()
        if options.extra_headers["Accept"] == nil {
            options.extra_headers["Accept"] = "application/binary"
        }
        return try OpenAISession.shared.SyncStreamResponse(
            url,
            payload: parameters,
            requestOptions: options,
            client: self.client,
            method: .get
        )
    }
}

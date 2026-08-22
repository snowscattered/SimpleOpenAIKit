//
//  VideoParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/11/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct VideoImageInputReference {
    public var file_id: String?
    public var image_url: String?
}
@CodableTraversal
public enum VideoInputReference {
    case file(FileParameters)
    case image(VideoImageInputReference)
}
@CodableLiteral
public enum VideoSeconds: String {
    case four = "4"
    case eight = "8"
    case twelve = "12"
}
@BaseModelNoWithExtra
public struct VideoReferenceInputParam {
    public var id: String
}
@CodableTraversal
public enum VideoVideo {
    case file(FileParameters)
    case video(VideoReferenceInputParam)
}

// MARK: - Create
@BaseModelWithExtra
public struct VideoCreateParamerters {
    public var model: String?
    public var prompt: String
    public var input_reference: VideoInputReference?
    public var seconds: VideoSeconds?
    public var size: String?
}

// MARK: - Retrieve
@BaseModelWithExtra
public struct VideoRetrieveParameter {
    @transient public var video_id: String
}

// MARK: - Delete
@BaseModelWithExtra
public struct VideoDeleteParameter {
    @transient public var video_id: String
}

// MARK: - List
@BaseModelWithExtra
public struct VideoListParameter {
    public var after: String?
    public var limit: Int?
    public var order: ListOrder?
}



// MARK: - Edit
@BaseModelWithExtra
public struct VideoEditParameter {
    public var prompt: String
    public var video: VideoVideo
}

// MARK: - Extend
@BaseModelWithExtra
public struct VideoExtendParameter {
    public var prompt: String
    public var seconds: VideoSeconds
    public var video: VideoVideo
}

// MARK: - Remix
@BaseModelWithExtra
public struct VideoRemixParameter {
    @transient public var video_id: String
    public var prompt: String
}


// MARK: - DownLoad
@CodableLiteral
public enum VideoDownloadContentVariant: String {
    case video
    case thumbnail
    case spritesheet
}
@BaseModelWithExtra
public struct VideoDownloadContentParameter {
    @transient public var video_id: String
    public var variant: VideoDownloadContentVariant?
}

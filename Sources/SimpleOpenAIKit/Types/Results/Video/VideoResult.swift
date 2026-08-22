//
//  VideoResult.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/11/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct VideoCreateError {
    public var code: String
    public var message: String
}
@CodableLiteral
public enum VideoStatus: String {
    case queued
    case in_progress
    case completed
    case failed
}

@BaseModelNoWithExtra
public struct VideoResult {
    public static let object: String = "video"
    public var id: String
    public var model: String
    public var created_at: Int
    public var completed_at: Int?
    public var status: VideoStatus
    public var error: VideoCreateError?
    public var expires_at: Int?
    public var progress: Int?
    public var prompt: String?
    public var remixed_from_video_id: String?
    public var seconds: VideoSeconds?
    public var size: String?
}

@BaseModelNoWithExtra
public struct VideoDeleteResult {
    public static let object: String = "video.deleted"
    public var id: String
    public var deleted: Bool
}

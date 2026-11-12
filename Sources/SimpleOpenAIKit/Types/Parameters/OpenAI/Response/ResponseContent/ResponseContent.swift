//
//  ResponseContent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/24/26.
//

import Foundation
import SimpleCodableMacro

@CodableLiteral
public enum ResponsePromptCacheBreakpointModel: String {
    case explicit
}
@BaseModelNoWithExtra
@PublicInit
public struct ResponsePromptCacheBreakpoint {
    public var model: ResponsePromptCacheBreakpointModel
}

@CodableByConstant
@nonexhaustive
public enum ResponseContent {
    case input_text(ResponseTextContent)
    case input_image(ResponseImageContent)
    case input_file(ResponseFileContent)
    // Extension OpenAI
    case encrypted_content(ResponseEncryptedContent)
    case input_video(ResponseVideoContent)
    case input_audio(ResponseAudioContent)
}

public extension ResponseContent {
    static func text(_ text: String) -> Self {
        .input_text(.init(text: text))
    }
    static func image(_ url: String, detail: ResponseImageDetail? = nil) -> Self {
        .input_image(.init(image_url: url, detail: detail))
    }
    static func file(_ file_id: String) -> Self {
        .input_file(.init(file_id: file_id))
    }
    static func encrypted(_ content: String) -> Self {
        .encrypted_content(.init(encrypted_content: content))
    }
    static func video(_ url: String) -> Self {
        .input_video(.init(video_url: url))
    }
    static func audio(_ data: String, format: ResponseAudioFormat? = nil) -> Self {
        .input_audio(.init(data: data, format: format))
    }
}

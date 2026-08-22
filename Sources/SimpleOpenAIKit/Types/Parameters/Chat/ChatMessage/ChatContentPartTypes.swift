//
//  ChatContentPartTypes.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

// MARK: - Content Parts
/// Text Contant
@BaseModelNoWithExtra
public struct PromptCacheBreakpoint {
    public static let mode: String = "explicit"
}
@BaseModelNoWithExtra
public struct ChatContentPartText {
    public static let type: String = "text"
    public var text: String
    public var prompt_cache_breakpoint: PromptCacheBreakpoint?
}
/// Refusal Content
@BaseModelNoWithExtra
public struct ChatContentPartRefusal: Codable {
    public static let type: String = "refusal"
    public var refusal: String
}
/// Image Content
@CodableLiteral
public enum ChatImageDetailLiteral: String {
    case auto, low, high
}
@BaseModelNoWithExtra
public struct ChatImageURL {
    public var url: String
    public var detail: ChatImageDetailLiteral?
}
@BaseModelNoWithExtra
public struct ChatContentPartImage {
    public static let type: String = "image_url"
    public var image_url: ChatImageURL
    public var prompt_cache_breakpoint: PromptCacheBreakpoint?
}
/// Video Content
@BaseModelNoWithExtra
public struct ChatVideoURL {
    public var url: String
}
@BaseModelNoWithExtra
public struct ChatContentPartVideo {
    public static let type: String = "video_url"
    public var video_url: ChatVideoURL
    public var prompt_cache_breakpoint: PromptCacheBreakpoint?
}
/// Audio Contant
@CodableLiteral
public enum ChatInputAudioFormatLiteral: String {
   case wav, mp3
}
@BaseModelNoWithExtra
public struct ChatInputAudio {
    public var data: String
    public var format: ChatInputAudioFormatLiteral?
}
@BaseModelWithExtra
public struct ChatContentPartAudio {
    public static let type: String = "input_audio"
    public var input_audio: ChatInputAudio
    public var prompt_cache_breakpoint: PromptCacheBreakpoint?
}
/// File Content
@BaseModelNoWithExtra
public struct ChatFileFile {
    public var file_data: String?
    public var file_id: String?
    public var filename: String?
}

@BaseModelNoWithExtra
public struct ChatContentPartFile {
    public static let type: String = "file"
    public var file: ChatFileFile
    public var prompt_cache_breakpoint: PromptCacheBreakpoint?
}
/// Custom Content
@BaseModelWithExtra
public struct ChatCustomPart {
    public var type: String
}

@CodableByConstant(defaultCase: "custom")
public enum ChatContentPart {
    case text(ChatContentPartText)
    case image(ChatContentPartImage)
    case input(ChatContentPartAudio)
    case file(ChatContentPartFile)
    // Extension OpenAI
    case video(ChatContentPartVideo)
    case custom(ChatCustomPart)
}

// MARK: - TextContent

@SingleOrArray
public enum ChatStringOrContentPartText {
    case string(String)
    case array([ChatContentPartText])
}
extension ChatStringOrContentPartText: ExpressibleByStringLiteral, ExpressibleByArrayLiteral {
    public init(stringLiteral value: String)                   { self = .string(value) }
    public init(arrayLiteral elements: ChatContentPartText...) { self = .array(elements) }
}

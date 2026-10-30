//
//  ResponseContent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/24/26.
//

import Foundation
import SimpleCodableMacro

@CodableLiteral
public enum ResponsePromptCacheBreakpointLiteral: String {
    case explicit
}
@BaseModelNoWithExtra
@PublicInit
public struct ResponsePromptCacheBreakpoint {
    public var model: ResponsePromptCacheBreakpointLiteral
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

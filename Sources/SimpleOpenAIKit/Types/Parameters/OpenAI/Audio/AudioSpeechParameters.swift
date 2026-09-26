//
//  AudioSpeechParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@CodableStringLiteralWithOther
public enum AudioSpeechResponseFormatLiteral {
    case mp3, opus, aac, flac, wav, pcm
    case other(String)
}

@CodableLiteral
public enum AudioSpeechStreamFormatLiteral: String {
    case sse, audio
}

@BaseModelWithExtra
@PublicInit
public struct AudioSpeechParameters {
    public var model: String
    public var input: String
    // Extension OpenAI: In OpenAI, this is a must
    public var voice: String?
    public var instructions: String?
    public var response_format: AudioSpeechResponseFormatLiteral?
    public var speed: Double?
    public var stream_format: AudioSpeechStreamFormatLiteral?
}

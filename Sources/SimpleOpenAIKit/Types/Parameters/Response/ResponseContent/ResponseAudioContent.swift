//
//  ResponseAudioContent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@CodableStringLiteralWithOther
public enum ResponseAudioFormatLiteral {
    case wav, mp3
    case other(String)
}

@BaseModelNoWithExtra
@PublicInit
public struct ResponseAudioContent {
    public static let type: String = "input_audio"
    public var data: String
    public var format: ResponseAudioFormatLiteral?
}

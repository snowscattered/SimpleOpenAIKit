//
//  ResponseAudioContent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@CodableLiteral
public enum ResponseAudioFormatLiteral: String {
    case wav, mp3
}

@BaseModelNoWithExtra
public struct ResponseAudioContent {
    public static let type: String = "input_audio"
    public var data: String
    public var format: ResponseAudioFormatLiteral?
}

//
//  RealtimeEventShare.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/15/26.
//

import Foundation
import SimpleCodableMacro

// Format
@CodableStringLiteralWithOther
public enum RealtimeAudioFormat {
    case `audio/pcm`
    case `audio/pcmu`
    case `audio/pcma`
    case other(String)
}
// MARK: Output Modalities
@CodableLiteral
public enum RealtimeModalites: String {
    case text, audio
}
// MARK: Tool Choice
@CodableByConstantAndSingle(singleCase: "option")
public enum RealtimeResponseToolChoice {
    case option(ResponseToolChoiceOptions)
    case function(ResponseToolChoiceFunction)
    case mcp(ResponseToolChoiceMcp)
}

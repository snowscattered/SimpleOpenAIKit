//
//  RealtimeEventShare.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/15/26.
//

import Foundation
import SimpleCodableMacro

// Format
@CodableLiteral
public enum RealtimeAudioFormat: String {
    case pcm = "audio/pcm"
    case pcmu = "audio/pcmu"
    case pcma = "audio/pcma"
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

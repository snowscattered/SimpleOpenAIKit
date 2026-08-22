//
//  BetaRealtimeShared.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/17/26.
//

import Foundation
import SimpleCodableMacro

public typealias BetaRealtimeInputAudioFormat  = BaseType
public typealias BetaRealtimeOutputAudioFormat = BaseType
@CodableLiteral
public enum BetaRealtimeModality: String {
    case audio, text
}

//
//  BetaRealtimeParamters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/16/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelWithExtra
public struct BetaRealtimeParameters {
    public var model: String
    public var call_id: String?
}

//
//  RealtimeParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/11/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelWithExtra
public struct RealtimeParameters {
    public var model: String
    public var call_id: String?
}

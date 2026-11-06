//
//  OpenAIReasoningEffort.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/31/26.
//

import Foundation
import SimpleCodableMacro

@CodableLiteral
public enum OpenAIReasoningEffort: String {
    case none, minimal, low, medium, high, xhigh, max
}

public typealias OpenAIMetaData = [String: String]

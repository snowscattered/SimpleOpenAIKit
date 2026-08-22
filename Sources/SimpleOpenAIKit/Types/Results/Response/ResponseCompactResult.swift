//
//  ResponseCompactResult.swift
//  SimpleOpenAIKit
//
//  Created by snow on 8/21/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ResponseCompactResult {
    public static let object: String = "response.compaction"
    public var id: String
    public var created_at: Int
    public var output: [ResponseOutputItem]
    public var usage: ResponseUsage
}

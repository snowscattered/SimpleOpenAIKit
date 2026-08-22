//
//  ResponseCustomToolCallItem.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ResponseCustomToolCallItem {
    public static let type: String = "custom_tool_call"
    public var id: String?
    public var call_id: String
    public var name: String
    public var input: String
    public var namespace: String?
}

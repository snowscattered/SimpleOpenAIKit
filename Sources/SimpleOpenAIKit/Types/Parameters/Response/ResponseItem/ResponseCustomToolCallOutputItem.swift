//
//  ResponseCustomToolCallOutputItem.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/23/26.
//

import Foundation
import SimpleCodableMacro

@CodableByConstant
public enum ResponseCustomToolCallOutputContent {
    case input_text(ResponseTextContent)
    case input_image(ResponseImageContent)
    case input_file(ResponseFileContent)
}

@SingleOrArray
public enum ResponseCustomToolCallOutput {
    case string(String)
    case array([ResponseCustomToolCallOutputContent])
}
extension ResponseCustomToolCallOutput: ExpressibleByStringLiteral {
   public init(stringLiteral value: String)                                   { self = .string(value) }
   public init(arrayLiteral elements: ResponseCustomToolCallOutputContent...) { self = .array(elements) }
}

@BaseModelNoWithExtra
public struct ResponseCustomToolCallOutputItem {
    public static let type: String = "custom_tool_call_output"
    public var id: String?
    public var call_id: String
    public var output: ResponseCustomToolCallOutput
    public var status: ResponseItemStatusLiteral?
    public var created_at: String?
}

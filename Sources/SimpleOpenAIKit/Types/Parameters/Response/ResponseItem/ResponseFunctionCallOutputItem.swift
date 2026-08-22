//
//  ResponseFunctionCallOutputItem.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@CodableByConstant
public enum ResponseFunctionCallOutputContent {
    case input_text(ResponseTextContent)
    case input_image(ResponseImageContent)
    case input_file(ResponseFileContent)
}

@SingleOrArray
public enum ResponseFunctionCallOutput {
    case string(String)
    case array([ResponseFunctionCallOutputContent])
}
extension ResponseFunctionCallOutput: ExpressibleByStringLiteral, ExpressibleByArrayLiteral {
   public init(stringLiteral value: String)                                 { self = .string(value) }
   public init(arrayLiteral elements: ResponseFunctionCallOutputContent...) { self = .array(elements) }
}

@BaseModelNoWithExtra
public struct ResponseFunctionCallOutputItem {
    public static let type: String = "function_call_output"
    public var id: String?
    public var call_id: String
    public var output: ResponseFunctionCallOutput
    public var status: ResponseItemStatusLiteral?
}

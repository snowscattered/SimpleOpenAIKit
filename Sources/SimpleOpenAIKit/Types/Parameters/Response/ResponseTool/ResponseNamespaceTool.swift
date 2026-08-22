//
//  ResponseNamespaceTool.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@CodableByConstant
public enum ResponseSimpleTool {
    case function(ResponseFunctionTool)
    case custom(ResponseCustomTool)
}

@BaseModelNoWithExtra
public struct ResponseNamespaceTool {
    public static let type: String = "namespace"
    public var description: String
    public var name: String
    public var tools: [ResponseSimpleTool]
}

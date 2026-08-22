//
//  MessageTool.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

// MARK: - Input Schema

@BaseModelWithExtra
public struct MessageInputSchemaTyped {
    public static let type: String = "object"
    public var properties: [String: BaseType]?
    public var required: [String]?
}

@CodableTraversal
public enum MessageInputSchema {
   case typed(MessageInputSchemaTyped)
   case dict([String: BaseType])
}

@CodableLiteral
public enum MessageBaseToolType: String {
   case custom
}

@BaseModelNoWithExtra
public struct MessageBaseTool {
    public var type: MessageBaseToolType?
    public var name: String
    public var input_schema: MessageInputSchema
    public var description: String?
    public var strict: Bool?
    
    public var cache_control: MessageCacheControlEphemeral?
    public var allowed_callers: [MessageAllowedCaller]?
    public var defer_loading: Bool?
    public var eager_input_streaming: Bool?
    public var input_examples: [[String: BaseType]]?
}

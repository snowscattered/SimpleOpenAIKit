//
//  ResponseFunctionCallItem.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ResponseFunctionCallItem {
    public static let type: String = "function_call"
    public var id: String?
    public var call_id: String
    public var name: String
    public var arguments: String
    public var namespace: String?
    public var status: ResponseItemStatusLiteral?
}

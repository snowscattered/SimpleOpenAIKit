//
//  OpenAIToolProtocol.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/9/26.
//

import Foundation
import SimpleOpenAIKitMacro

public protocol ToolProtocol {
    associatedtype Argument: MainArgument
    associatedtype Output
    static var name: String { get }
    static var description: String { get }
    static var strict: Bool? { get }
    static var defer_loading: Bool? { get }
    static func call(arguments: Argument) async throws -> Output
}
public extension ToolProtocol {
    static var defer_loading: Bool? { nil }
    static func call(
        _ data: Data
    ) async throws -> Output {
        let argument = try JSONDecoder().decode(Argument.self, from: data)
        return try await call(arguments: argument)
    }
}
public extension ChatTool {
    init<T: ToolProtocol>(_ tool: T.Type) {
        self = .function_tool(.init(function: .init(
            name: T.name,
            description: T.description,
            parameters: T.Argument.ArgumentSchema,
            strict: T.strict
        )))
    }
}
public extension ResponseTool {
    init<T: ToolProtocol>(
        _ tool: T.Type,
        Async: Bool? = nil,
        allowed_callers: [ResponseToolAllowedCallers]? = nil,
        output_schema: [String : BaseType]? = nil
    ) {
        self = .function(.init(
            name: T.name,
            description: T.description,
            parameters: T.Argument.ArgumentSchema,
            strict: T.strict,
            defer_loading: T.defer_loading,
            async: Async,
            allowed_callers: allowed_callers,
            output_schema: output_schema
        ))
    }
}
public extension MessageTool {
    init<T: ToolProtocol>(
        _ tool: T.Type,
        cache_control: MessageCacheControlEphemeral? = nil,
        allowed_callers: [MessageAllowedCaller]? = nil,
        eager_input_streaming: Bool? = nil,
        input_examples: [[String: BaseType]]? = nil
    ) {
        self = .tool(.init(
            name: T.name,
            description: T.description,
            input_schema: .dict(T.Argument.ArgumentSchema),
            strict: T.strict,
            defer_loading: T.defer_loading,

            cache_control: cache_control,
            allowed_callers: allowed_callers,
            eager_input_streaming: eager_input_streaming,
            input_examples: input_examples
        ))
    }
}

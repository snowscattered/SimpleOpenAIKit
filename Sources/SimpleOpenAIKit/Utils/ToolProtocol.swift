//
//  OpenAIToolProtocol.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/9/26.
//

import Foundation
import SimpleOpenAIKitMacro

public protocol ToolProtocol {
    associatedtype Arguments: MainArgument
    associatedtype Output
    var name: String { get }
    var description: String { get }
    var strict: Bool? { get }
    var defer_loading: Bool? { get }
    func call(arguments: Arguments) async throws -> Output
}
public extension ToolProtocol {
    var defer_loading: Bool? { nil }
    func call( _ data: Data ) async throws -> Output {
        let argument = try JSONDecoder().decode(Arguments.self, from: data)
        return try await call(arguments: argument)
    }
}
public extension ChatTool {
    init<T: ToolProtocol>(_ tool: T) {
        self = .function_tool(.init(function: .init(
            name: tool.name,
            description: tool.description,
            parameters: T.Arguments.ArgumentSchema,
            strict: tool.strict
        )))
    }
}
public extension ResponseTool {
    init<T: ToolProtocol>(
        _ tool: T,
        isAsync: Bool? = nil,
        allowed_callers: [ResponseToolAllowedCallers]? = nil,
        output_schema: [String: BaseType]? = nil
    ) {
        self = .function(.init(
            name: tool.name,
            description: tool.description,
            parameters: T.Arguments.ArgumentSchema,
            strict: tool.strict,
            defer_loading: tool.defer_loading,
            async: isAsync,
            allowed_callers: allowed_callers,
            output_schema: output_schema
        ))
    }
}
public extension MessageTool {
    init<T: ToolProtocol>(
        _ tool: T,
        cache_control: MessageCacheControlEphemeral? = nil,
        allowed_callers: [MessageAllowedCaller]? = nil,
        eager_input_streaming: Bool? = nil,
        input_examples: [[String: BaseType]]? = nil
    ) {
        self = .tool(.init(
            name: tool.name,
            description: tool.description,
            input_schema: .dict(T.Arguments.ArgumentSchema),
            strict: tool.strict,
            defer_loading: tool.defer_loading,

            cache_control: cache_control,
            allowed_callers: allowed_callers,
            eager_input_streaming: eager_input_streaming,
            input_examples: input_examples
        ))
    }
}

//
//  OpenAIToolProtocol.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/9/26.
//

import Foundation
import SimpleOpenAIKitMacro

/// A callable tool expressed as a type instead of a hand-written schema.
///
/// `Arguments` conforms to `MainArgument`, so the `@mainArgument` macro generates both the
/// Codable members and the JSON schema sent to the provider. Registering a tool is therefore a
/// single declaration: `ChatTool(MyTool.self)`, `ResponseTool(MyTool.self)`, `MessageTool(MyTool.self)`.
public protocol ToolProtocol {
    /// The argument object the model produces, validated against the generated schema.
    associatedtype Arguments: MainArgument
    /// The value handed back to the model; the caller is responsible for encoding it.
    associatedtype Output
    /// The exact name the model must call this tool by.
    static var name: String { get }
    /// Model-facing description of when and why to use the tool.
    static var description: String { get }
    /// Force the provider to follow the schema exactly; `nil` keeps the provider default.
    static var strict: Bool? { get }
    /// Withhold the tool until the model needs it (server-side lazy loading).
    static var defer_loading: Bool? { get }
    /// Execute the tool. `@concurrent` leaves the caller's actor so a stream can keep draining.
    @concurrent @discardableResult static func call(arguments: Arguments) async throws -> Output
}
public extension ToolProtocol {
    // Foundation Model
//    var name: String { Self.name }
    var description: String { Self.description }
    /// Instance-side bridge to the static implementation.
    @concurrent func call(arguments: Arguments) async throws -> Output {
        return try await Self.call(arguments: arguments)
    }

    static var defer_loading: Bool? { nil }
    static var strict: Bool? { Self.Arguments.__strict }
    /// Entry point for a raw tool call arriving from a response or stream: decodes `data`
    /// into `Arguments` and forwards it to `call(arguments:)`.
    @concurrent @discardableResult static func call(_ data: Data) async throws -> Output {
        let arguments = try JSONDecoder().decode(Arguments.self, from: data)
        return try await call(arguments: arguments)
    }
}
public extension ChatTool {
    /// Build the OpenAI Chat Completions tool declaration from a `ToolProtocol` type.
    init<T: ToolProtocol>(_: T.Type) {
        self = .function_tool(.init(function: .init(
            name: T.name,
            description: T.description,
            parameters: T.Arguments.ArgumentSchema,
            strict: T.strict
        )))
    }
}
public extension ResponseTool {
    /// Build the OpenAI Responses tool declaration from a `ToolProtocol` type.
    init<T: ToolProtocol>(
         _: T.Type,
        Async: Bool? = nil,
        allowed_callers: [ResponseToolAllowedCallers]? = nil,
        output_schema: [String: BaseType]? = nil
    ) {
        self = .function(.init(
            name: T.name,
            description: T.description,
            parameters: T.Arguments.ArgumentSchema,
            strict: T.strict,
            defer_loading: T.defer_loading,
            async: Async,
            allowed_callers: allowed_callers,
            output_schema: output_schema
        ))
    }
}
public extension MessageTool {
    /// Build the Anthropic Messages tool declaration from a `ToolProtocol` type.
    init<T: ToolProtocol>(
        _: T.Type,
        cache_control: MessageCacheControlEphemeral? = nil,
        allowed_callers: [MessageAllowedCaller]? = nil,
        eager_input_streaming: Bool? = nil,
        input_examples: [[String: BaseType]]? = nil
    ) {
        self = .tool(.init(
            name: T.name,
            description: T.description,
            input_schema: .dict(T.Arguments.ArgumentSchema),
            strict: T.strict,
            defer_loading: T.defer_loading,

            cache_control: cache_control,
            allowed_callers: allowed_callers,
            eager_input_streaming: eager_input_streaming,
            input_examples: input_examples
        ))
    }
}

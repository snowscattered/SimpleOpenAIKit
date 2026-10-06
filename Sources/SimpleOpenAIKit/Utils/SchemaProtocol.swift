//
//  SchemaProtocol.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/10/4.
//

import Foundation
import SimpleOpenAIKitMacro

/// A structured output shape expressed as a type instead of a hand-written JSON schema.
///
/// `Arguments` conforms to `MainArgument`, so the macro generates both the Codable members and the
/// JSON schema sent to the provider. `@MainSchema` writes them on the payload type itself, leaving
/// only this conformance to declare:
///
/// ```swift
/// @MainSchema(description: "Fetch the weather for a given location.", strict: true)
/// struct Weather: SchemaProtocol { ... }
/// ```
///
/// `Weather` is then both the schema and the type the response decodes into, and constraining a
/// response is a single declaration: `ChatResponseFormat(Weather.self)`,
/// `ResponseFormatTextConfig(Weather.self)`, `MessageJSONOutputFormat(Weather.self)`.
/// Unlike `ToolProtocol` there is nothing to call: the provider returns the JSON and the caller
/// decodes it into `Arguments`.
public protocol SchemaProtocol: Codable & Sendable {
    /// The object the model must produce, validated against the generated schema.
    associatedtype Arguments: MainArgument
    /// The name reported to the provider next to the schema; `@MainSchema` takes it from the type.
    static var name: String { get }
    /// Model-facing description of what the output represents.
    static var description: String? { get }
    /// Force the provider to follow the schema exactly; `nil` keeps the provider default.
    static var strict: Bool? { get }
}

public extension ChatResponseFormat {
    /// Build the OpenAI Chat Completions `response_format` from a `SchemaProtocol` type.
    init<T: SchemaProtocol>(_: T.Type) {
        self = .json_schema(.init(json_schema: .init(
            name: T.name,
            description: T.description,
            schema: T.Arguments.ArgumentSchema,
            strict: T.strict
        )))
    }
}
public extension ResponseFormatTextConfig {
    /// Build the OpenAI Responses `text.format` from a `SchemaProtocol` type.
    init<T: SchemaProtocol>(_: T.Type) {
        self = .json_schema(.init(
            name: T.name,
            description: T.description,
            schema: T.Arguments.ArgumentSchema,
            strict: T.strict
        ))
    }
}
public extension MessageJSONOutputFormat {
    /// Build the Anthropic Messages `output_config.format` from a `SchemaProtocol` type.
    /// Anthropic only carries the schema itself, so `name`, `description` and `strict` are dropped.
    init<T: SchemaProtocol>(_: T.Type) {
        self = .init(schema: T.Arguments.ArgumentSchema)
    }
}

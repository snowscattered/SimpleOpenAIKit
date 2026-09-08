//
//  ToolArgumentProtocol.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/6/26.
//

import SimpleCodableMacro

public protocol ArgumentSchema: Encodable & Sendable {
    static var ArgumentSchema: [String: BaseType] { get }
}
public extension ArgumentSchema {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(Self.ArgumentSchema)
    }
}

public protocol MainArgument: ArgumentSchema {}
public protocol ReferArgument: ArgumentSchema {}
public protocol EnumArgument: Encodable & Sendable {
    static var ArgumentSchema: [String: BaseType] { get }
}
public extension EnumArgument {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(Self.ArgumentSchema)
    }
}
public protocol AnyOfArgument: Encodable & Sendable {
    static var ArgumentSchema: [String: BaseType] { get }
}
public extension AnyOfArgument {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(Self.ArgumentSchema)
    }
}

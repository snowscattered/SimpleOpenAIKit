//
//  SystemOneShared.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026-09-25.
//

import SimpleCodableMacro

@CodableTraversal
public indirect enum SystemOneJSONConent: Sendable {
    case value(BaseType)
    case array([SystemOneJSONConent?])
    case dict([String: SystemOneJSONConent?])
    case image(TypeSafeImage)

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .image(let image):
            try container.encode(image.reference)
        case .array(let values):
            try container.encode(values)
        case .dict(let values):
            try container.encode(values)
        case .value(let value):
            try value.encode(to: encoder)
        }
    }
}

public extension SystemOneJSONConent {
    static func string(_ value: String) -> SystemOneJSONConent { .value(.string(value)) }
    static func bool(_ value: Bool) -> SystemOneJSONConent { .value(.bool(value)) }
    static func int(_ value: Int) -> SystemOneJSONConent { .value(.int(value)) }
    static func double(_ value: Double) -> SystemOneJSONConent { .value(.double(value)) }
}

extension SystemOneJSONConent: ExpressibleByStringLiteral,
                               ExpressibleByArrayLiteral,
                               ExpressibleByDictionaryLiteral,
                               ExpressibleByBooleanLiteral,
                               ExpressibleByIntegerLiteral,
                               ExpressibleByFloatLiteral {
    public init(stringLiteral value: String) { self = .value(.string(value)) }
    public init(arrayLiteral elements: SystemOneJSONConent?...) { self = .array(elements) }
    public init(dictionaryLiteral elements: (String, SystemOneJSONConent?)...) {
        var dict: [String: SystemOneJSONConent?] = [:]
        for (key, value) in elements { dict[key] = value }
        self = .dict(dict)
    }
    public init(booleanLiteral value: Bool) { self = .value(.bool(value)) }
    public init(integerLiteral value: Int) { self = .value(.int(value)) }
    public init(floatLiteral value: Double) { self = .value(.double(value)) }
}

extension SystemOneJSONConent {
    func resolved(
        _ aliases: [String: String],
        into assets: inout [String: TypeSafeImage]
    ) -> Self {
        switch self {
        case .image(let image):
            if let alias = aliases[image.reference] {
                return .value(.string(alias))
            }
            assets[image.reference] = image
            return self
        case .array(let values):
            return .array(values.map {
                $0?.resolved(aliases, into: &assets)
            })
        case .dict(let values):
            return .dict(values.mapValues {
                $0?.resolved(aliases, into: &assets)
            })
        case .value:
            return self
        }
    }
}

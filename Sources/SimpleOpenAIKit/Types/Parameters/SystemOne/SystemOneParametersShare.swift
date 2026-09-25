//
//  SystemOneShared.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026-09-25.
//

import SimpleCodableMacro

@CodableTraversal
public enum SystemOneJSONConent: Sendable {
    case string(String)
    case array([BaseType?])
    case dict([String: BaseType?])
}
extension SystemOneJSONConent: ExpressibleByStringLiteral,
                               ExpressibleByArrayLiteral,
                               ExpressibleByDictionaryLiteral {
    public init(stringLiteral value: String) { self = .string(value) }
    public init(arrayLiteral elements: BaseType?...) { self = .array(elements) }
    public init(dictionaryLiteral elements: (String, BaseType?)...) {
        var dict: [String: BaseType?] = [:]
        for (key, value) in elements { dict[key] = value }
        self = .dict(dict)
    }
}

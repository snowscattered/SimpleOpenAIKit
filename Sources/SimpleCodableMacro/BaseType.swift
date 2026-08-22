//
//  BaseType.swift
//  SimpleCodableMacro
//
//  Created by snow on 5/7/26.
//

import Foundation
// MARK: - BaseType
public indirect enum BaseType: Codable & Sendable {
    case null
    case bool(Bool)
    case int(Int)
    case double(Double)
    case string(String)
    case array([BaseType])
    case dict([String: BaseType])

    nonisolated public init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if c.decodeNil()                                  { self = .null;      return }
        if let v = try? c.decode(Bool.self)               { self = .bool(v);   return }
        if let v = try? c.decode(Int.self)                { self = .int(v);    return }
        if let v = try? c.decode(Double.self)             { self = .double(v); return }
        if let v = try? c.decode(String.self)             { self = .string(v); return }
        if let v = try? c.decode([BaseType].self)         { self = .array(v);  return }
        if let v = try? c.decode([String: BaseType].self) { self = .dict(v);   return }
        throw DecodingError.dataCorruptedError(in: c, debugDescription: "Unsupported JSON value")
    }

    nonisolated public func encode(to encoder: Encoder) throws {
        var c = encoder.singleValueContainer()
        switch self {
        case .null         : try c.encodeNil()
        case .bool(let v)  : try c.encode(v)
        case .int(let v)   : try c.encode(v)
        case .double(let v): try c.encode(v)
        case .string(let v): try c.encode(v)
        case .array(let v) : try c.encode(v)
        case .dict(let v)  : try c.encode(v)
        }
    }
}
extension BaseType: ExpressibleByBooleanLiteral,
                    ExpressibleByIntegerLiteral,
                    ExpressibleByFloatLiteral,
                    ExpressibleByStringLiteral,
                    ExpressibleByArrayLiteral,
                    ExpressibleByDictionaryLiteral {
    public init(booleanLiteral value: Bool)                         { self = .bool(value) }
    public init(integerLiteral value: Int)                          { self = .int(value) }
    public init(floatLiteral value: Double)                         { self = .double(value) }
    public init(stringLiteral value: String)                        { self = .string(value) }
    public init(arrayLiteral elements: BaseType...)                 { self = .array(elements) }
    public init(dictionaryLiteral elements: (String, BaseType)...) {
        var dict = [String: BaseType](minimumCapacity: elements.count)
        for (key, value) in elements { dict[key] = value }
        self = .dict(dict)
    }
}
extension BaseType {
    public subscript(key: String) -> BaseType? {
        get {
            guard case .dict(let dict) = self else { return nil }
            return dict[key]
        }
        set {
            guard case .dict(var dict) = self else { return }
            dict[key] = newValue
            self = .dict(dict)
        }
    }
}
extension BaseType {
    public func value<T>() -> T? {
        switch self {
        case .int(let v): return v as? T
        case .double(let v): return v as? T
        case .bool(let v): return v as? T
        case .string(let v): return v as? T
        case .array(let v): return v as? T
        case .dict(let v): return v as? T
        case .null: return nil
        }
    }
}
// MARK: - BaseModel
public protocol BaseModel: Codable & Sendable {
    init(from decoder: Decoder) throws
}
public extension BaseModel {
    func after() throws -> Void { }
    func json() throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        let data = try encoder.encode(self)
        guard let string = String(data: data, encoding: .utf8) else {
            throw EncodingError.invalidValue(
                self,
                EncodingError.Context(
                    codingPath: [],
                    debugDescription: "Failed to convert the encoded data to a UTF‑8 string."
                )
            )
        }
        return string
    }
}
// MARK: - BaseModelExtra
public protocol BaseModelNoWithExtra: BaseModel { }
public extension BaseModelNoWithExtra {
    func update<T>(_ keyPath: WritableKeyPath<Self, T>, to value: T) -> Self {
        var copy = self
        copy[keyPath: keyPath] = value
        return copy
    }
}
public protocol BaseModelWithExtra: BaseModelNoWithExtra {
    var extra: [String: BaseType] { get set }
}

package struct VoidStruct: Codable & Sendable { }

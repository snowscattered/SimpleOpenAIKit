//
//  BaseType.swift
//  SimpleCodableMacro
//
//  Created by snow on 5/7/26.
//

import Foundation
// MARK: - BaseType
/// A JSON value Swift can hold without a matching model: null, bool, int, double, string, array or object.
///
/// Tool schemas and the `extra` passthrough fields are built from this, so unknown keys survive a
/// decode and re-encode round trip.
public indirect enum BaseType: Codable & Sendable {
    case null
    case bool(Bool)
    case int(Int)
    case double(Double)
    case string(String)
    case array([BaseType])
    case dict([String: BaseType])

    nonisolated public init(from decoder: any Decoder) throws {
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

    nonisolated public func encode(to encoder: any Encoder) throws {
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
/// Lets any JSON literal be written directly as a `BaseType`.
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
    public init(_ object: some Codable & Sendable) throws {
        let data = try JSONEncoder().encode(object)
        self = .dict(try JSONDecoder().decode([String: BaseType].self, from: data))
    }
}
/// Turn any Codable value into a dictionary of JSON values.
public extension Dictionary where Key == String, Value == BaseType {
    init(_ object: some Codable & Sendable) throws {
        let data = try JSONEncoder().encode(object)
        self = try JSONDecoder().decode([String: BaseType].self, from: data)
    }
}

extension BaseType {
    /// Read or replace one key of a `.dict` value; other cases are left alone.
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
    /// Hand back the stored scalar as `T`, or `nil` when this case does not hold one.
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
/// Marker for a generated API model: `Codable`, `Sendable`, and able to dump itself as JSON.
public protocol BaseModel: Codable & Sendable { }
public extension BaseModel {
    /// Hook for generated models to run after decoding; the default does nothing.
    func after() throws -> Void { }
    /// Encode to a sorted, pretty-printed JSON string.
    func json() throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        let data = try encoder.encode(self)
        return String(decoding: data, as: UTF8.self)
    }
}
// MARK: - BaseModelExtra
/// A model whose fields are exactly the ones it declares, with no room for unknown keys.
public protocol BaseModelNoWithExtra: BaseModel { }
public extension BaseModelNoWithExtra {
    /// Return a copy with one key path replaced, for terse call sites.
    func update<T>(_ keyPath: WritableKeyPath<Self, T>, to value: T) -> Self {
        var copy = self
        copy[keyPath: keyPath] = value
        return copy
    }
}
/// A model that also keeps the JSON keys it does not declare in `extra`.
@dynamicMemberLookup
public protocol BaseModelWithExtra: BaseModelNoWithExtra {
    var extra: [String: BaseType] { get set }
    subscript(dynamicMember member: String) -> BaseType? { get }
}
extension BaseModelWithExtra {
    public subscript<T>(dynamicMember member: String) -> T? { extra[member]?.value() }
}

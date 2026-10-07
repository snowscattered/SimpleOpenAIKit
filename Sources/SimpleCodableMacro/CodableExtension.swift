//
//  CodableExtension.swift
//  SimpleCodableMacro
//
//  Runtime support for `@BaseModelFieldAlias`.
//

import Foundation

// MARK: - Alias-aware decoding
public extension KeyedDecodingContainer {
    /// Decode the first JSON name a field answers to, so one property can accept several spellings.
    /// - Parameter aliasCases: the accepted keys in priority order, the Swift property name first.
    ///   When none of them is present the error is reported for that first key.
    func decode<T: Decodable>(_ type: T.Type, aliasCases: [Key]) throws -> T {
        precondition(!aliasCases.isEmpty, "@BaseModelFieldAlias generated an empty key list")
        for key in aliasCases where contains(key) {
            return try decode(type, forKey: key)
        }
        return try decode(type, forKey: aliasCases[0])
    }

    /// Decode the first JSON name a field answers to, or return `nil` when none of them is present.
    func decodeIfPresent<T: Decodable>(_ type: T.Type, aliasCases: [Key]) throws -> T? {
        for key in aliasCases where contains(key) {
            return try decodeIfPresent(type, forKey: key)
        }
        return nil
    }
}

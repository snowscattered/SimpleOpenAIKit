//
//  CollectionExtension.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//

// MARK: - Dictionary Merge Operator
import Foundation

extension Dictionary {
    /// Merges two dictionaries, with values from `rhs` overriding those in `lhs`.
    /// New keys from `rhs` are added to the result.
    ///
    /// - Parameters:
    ///   - lhs: The base dictionary.
    ///   - rhs: The dictionary whose values take precedence.
    /// - Returns: A new dictionary containing all key-value pairs from both dictionaries,
    ///           with values from `rhs` overriding those in `lhs` for matching keys.
    static package func | (lhs: Dictionary, rhs: Dictionary) -> Dictionary {
        var result = lhs
        result.merge(rhs) { $1 }
        return result
    }
}

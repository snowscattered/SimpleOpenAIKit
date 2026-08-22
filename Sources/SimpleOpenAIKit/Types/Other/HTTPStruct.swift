//
//  HTTPStruct.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/15/26.
//
import Foundation
import SimpleCodableMacro

public typealias Header = [String: String]
public typealias Query = [String: BaseType]
public typealias Body = [String: BaseType]


public enum ArrayEncoding {
    /// eq: `tags[]=swift&tags[]=ios`
    case brackets
    /// eq: `tags[0]=swift&tags[1]=ios`
    case indexed
}
extension Query {
    func toURLQueryItems(arrayEncoding: ArrayEncoding = .indexed) -> [URLQueryItem] {
        var items: [URLQueryItem] = []
        for (key, value) in self {
            items.append(contentsOf: flatten(key: key, value: value, arrayEncoding: arrayEncoding))
        }
        return items
    }
    private func flatten(key: String, value: BaseType, arrayEncoding: ArrayEncoding) -> [URLQueryItem] {
        switch value {
        case .null: return [URLQueryItem(name: key, value: "")]
        case .bool(let v): return [URLQueryItem(name: key, value: v ? "true" : "false")]
        case .int(let v): return [URLQueryItem(name: key, value: String(v))]
        case .double(let v): return [URLQueryItem(name: key, value: String(v))]
        case .string(let v): return [URLQueryItem(name: key, value: v)]
        case .array(let arr):
            if arr.isEmpty {
                return []
            }
            var items: [URLQueryItem] = []
            for (index, item) in arr.enumerated() {
                let itemKey: String
                switch arrayEncoding {
                case .brackets:
                    itemKey = "\(key)[]"
                case .indexed:
                    itemKey = "\(key)[\(index)]"
                }
                items.append(contentsOf: flatten(key: itemKey, value: item, arrayEncoding: arrayEncoding))
            }
            return items
        case .dict(let dict):
            var items: [URLQueryItem] = []
            for (subKey, subValue) in dict {
                let dictKey = "\(key)[\(subKey)]"
                items.append(contentsOf: flatten(key: dictKey, value: subValue, arrayEncoding: arrayEncoding))
            }
            return items
        }
    }
}

//
//  ResponseFileSearchTool.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro


@CodableLiteral
public enum ResponseComparisonTypeLiteral: String {
    case eq, ne, gt, gte, lt, lte
}
@CodableLiteral
public enum ResponseRankerLiteral: String {
    case auto
    case default_2024_11_15 = "default-2024-11-15"
}

@BaseModelNoWithExtra
public struct ResponseComparisonFilter {
    public var key: String
    public var type: ResponseComparisonTypeLiteral
    public var value: BaseType
}

@CodableLiteral
public enum ResponseCompoundFilterTypeLiteral: String {
    case and, or
}
@BaseModelNoWithExtra
public struct ResponseCompoundFilter {
    public var filters: [BaseType]
    public var type: ResponseCompoundFilterTypeLiteral
}

public enum ResponseFilters: BaseModel {
    case comparison(ResponseComparisonFilter)
    case compound(ResponseCompoundFilter)

    private enum CodingKeys: String, CodingKey { case type }

    public nonisolated init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let t = try c.decode(String.self, forKey: .type)
        let s = try decoder.singleValueContainer()
        switch t {
        case "and", "or": self = .compound(try s.decode(ResponseCompoundFilter.self))
        default:          self = .comparison(try s.decode(ResponseComparisonFilter.self))
        }
    }

    public nonisolated func encode(to encoder: Encoder) throws {
        var c = encoder.singleValueContainer()
        switch self {
        case .comparison(let v): try c.encode(v)
        case .compound(let v):   try c.encode(v)
        }
    }
}

@BaseModelNoWithExtra
public struct ResponseRankingOptionsHybridSearch {
    public var embedding_weight: Double?
    public var text_weight: Double?
}

@BaseModelNoWithExtra
public struct ResponseRankingOptions {
    public var hybrid_search: ResponseRankingOptionsHybridSearch?
    public var ranker: ResponseRankerLiteral?
    public var score_threshold: Double?
}

@BaseModelNoWithExtra
public struct ResponseFileSearchTool {
    public static let type: String = "file_search"
    public var vector_store_ids: [String]
    public var max_num_results: Int?
    public var filters: ResponseFilters?
    public var ranking_options: ResponseRankingOptions?
}

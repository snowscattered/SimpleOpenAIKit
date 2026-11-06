//
//  ResponseFileSearchTool.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro


@CodableLiteral
public enum ResponseComparisonType: String {
    case eq, ne, gt, gte, lt, lte
}
@BaseModelNoWithExtra
@PublicInit
public struct ResponseComparisonFilter {
    public var type: ResponseComparisonType
    public var key: String
    public var value: BaseType
}

@CodableLiteral
public enum ResponseCompoundFilterType: String {
    case and, or
}
@BaseModelNoWithExtra
@PublicInit
public struct ResponseCompoundFilter {
    public var type: ResponseCompoundFilterType
    public var filters: [BaseType]
}

@CodableByConstant
public enum ResponseFilters {
    @MultiConstant(["eq", "ne", "gt", "gte", "lt", "lte"])
    case comparison(ResponseComparisonFilter)
    @MultiConstant(["and", "or"])
    case compound(ResponseCompoundFilter)
}

@BaseModelNoWithExtra
@PublicInit
public struct ResponseRankingOptionsHybridSearch {
    public var embedding_weight: Double?
    public var text_weight: Double?
}
@CodableLiteral
public enum ResponseRanker: String {
    case auto
    case default_2024_11_15 = "default-2024-11-15"
}
@BaseModelNoWithExtra
@PublicInit
public struct ResponseRankingOptions {
    public var hybrid_search: ResponseRankingOptionsHybridSearch?
    public var ranker: ResponseRanker?
    public var score_threshold: Double?
}

@BaseModelNoWithExtra
@PublicInit
public struct ResponseFileSearchTool {
    public static let type: String = "file_search"
    public var vector_store_ids: [String]
    public var max_num_results: Int?
    public var filters: ResponseFilters?
    public var ranking_options: ResponseRankingOptions?
}

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
@BaseModelNoWithExtra
public struct ResponseComparisonFilter {
    public var type: ResponseComparisonTypeLiteral
    public var key: String
    public var value: BaseType
}

@CodableLiteral
public enum ResponseCompoundFilterTypeLiteral: String {
    case and, or
}
@BaseModelNoWithExtra
public struct ResponseCompoundFilter {
    public var type: ResponseCompoundFilterTypeLiteral
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
public struct ResponseRankingOptionsHybridSearch {
    public var embedding_weight: Double?
    public var text_weight: Double?
}
@CodableLiteral
public enum ResponseRankerLiteral: String {
    case auto
    case default_2024_11_15 = "default-2024-11-15"
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

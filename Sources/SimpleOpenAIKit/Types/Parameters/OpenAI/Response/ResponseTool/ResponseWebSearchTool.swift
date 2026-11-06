//
//  ResponseWebSearchTool.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct ResponseWebSearchFilters {
    public var allowed_domains: [String]?
}

@BaseModelNoWithExtra
@PublicInit
public struct ResponseWebSearchUserLocation {
    public let type: String? = "approximate"
    public var city: String?
    public var country: String?
    public var region: String?
    public var timezone: String?
}

@CodableLiteral
public enum ResponseWebSearchContextSize: String {
    case low, medium, high
}

@BaseModelNoWithExtra
@PublicInit
public struct ResponseWebSearchTool {
    public static let type: String = "web_search"
    public var external_web_access: Bool?
    public var filters: ResponseWebSearchFilters?
    public var search_context_size: ResponseWebSearchContextSize?
    public var user_location: ResponseWebSearchUserLocation?
}

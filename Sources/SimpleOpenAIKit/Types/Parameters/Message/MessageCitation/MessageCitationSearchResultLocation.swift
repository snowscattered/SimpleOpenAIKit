//
//  MessageCitationSearchResultLocation.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct MessageCitationSearchResultLocation {
    public static let type: String = "search_result_location"
    public var cited_text: String
    public var end_block_index: Int
    public var search_result_index: Int
    public var source: String
    public var start_block_index: Int
    public var title: String?
}

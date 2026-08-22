//
//  MessageCitationWebSearchResultLocation.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct MessageCitationWebSearchResultLocation {
    public static let type: String = "web_search_result_location"
    public var cited_text: String
    public var encrypted_index: String
    public var title: String?
    public var url: String
}

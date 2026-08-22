//
//  MessageCitationPageLocation.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct MessageCitationPageLocation {
    public static let type: String = "page_location"
    public var cited_text: String
    public var document_index: Int
    public var document_title: String?
    public var end_page_number: Int
    public var start_page_number: Int
}

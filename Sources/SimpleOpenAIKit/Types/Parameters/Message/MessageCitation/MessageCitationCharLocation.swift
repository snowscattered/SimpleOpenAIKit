//
//  MessageCitationCharLocation.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct MessageCitationCharLocation {
    public static let type: String = "char_location"
    public var cited_text: String
    public var document_index: Int
    public var document_title: String?
    public var end_char_index: Int
    public var start_char_index: Int
}

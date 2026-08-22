//
//  MessageCitationContentBlockLocation.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct MessageCitationContentBlockLocation {
    public static let type: String = "content_block_location"
    public var cited_text: String
    public var document_index: Int
    public var document_title: String?
    public var end_block_index: Int
    public var start_block_index: Int
}

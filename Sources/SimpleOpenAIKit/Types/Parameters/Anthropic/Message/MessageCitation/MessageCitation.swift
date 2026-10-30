//
//  MessageCitation.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@CodableByConstant
@nonexhaustive
public enum MessageCitation {
    case char_location(MessageCitationCharLocation)
    case page_location(MessageCitationPageLocation)
    case content_block_location(MessageCitationContentBlockLocation)
    case web_search_result_location(MessageCitationWebSearchResultLocation)
    case search_result_location(MessageCitationSearchResultLocation)
}

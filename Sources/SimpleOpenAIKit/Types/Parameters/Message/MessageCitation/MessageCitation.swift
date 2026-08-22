//
//  MessageCitation.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@CodableByConstant
public enum MessageCitation {
    case char_location(MessageCitationCharLocation)
    case content_block_location(MessageCitationContentBlockLocation)
    case page_location(MessageCitationPageLocation)
    case search_result_location(MessageCitationSearchResultLocation)
    case web_search_result_location(MessageCitationWebSearchResultLocation)
}

//
//  ResponseReasoningItem.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct ResponseReasoningContent {
    public static let type: String = "reasoning_text"
    public var text: String
}

@BaseModelNoWithExtra
@PublicInit
public struct ResponseReasoningSummary {
    public static let type: String = "summary_text"
    public var text: String
}

@BaseModelNoWithExtra
@PublicInit
public struct ResponseReasoningItem {
    public static let type: String = "reasoning"
    public var id: String?
    public var content: [ResponseReasoningContent]?
    public var summary: [ResponseReasoningSummary]?
    public var encrypted_content: String?
    public var status: ResponseItemStatusLiteral?
}

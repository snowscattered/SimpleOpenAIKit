//
//  RealtimeItemShare.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/14/26.
//

import Foundation
import SimpleCodableMacro

// MARK: ConversationItem Share
@CodableLiteral
public enum RealtimeItemStatus: String {
    case completed, incomplete, in_progress
}
@CodableByConstant(field: "role")
public enum RealtimeMessageConversationItem {
    public static let type = "message"
    case system(RealtimeSystemMessageConversationItem)
    case user(RealtimeUserMessageConversationItem)
    case assistant(RealtimeAssistantMessageConversationItem)
}

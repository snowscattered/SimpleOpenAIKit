//
//  RealtimeItem.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/14/26.
//

import Foundation
import SimpleCodableMacro

@CodableByConstant
public enum RealtimeConversationItem {
    case messages(RealtimeMessageConversationItem)
    case functionCall(RealtimeFunctionCallItem)
    case functionCallOutput(RealtimeFunctionCallOutputItem)
    case mcpApprovalRequest(RealtimeMcpApprovalRequestItem)
    case mcpApprovalResponse(RealtimeMcpApprovalResponseItem)
    case mcpListTool(RealtimeMcpListToolsItem)
    case mcpToolCall(RealtimeMcpToolCallItem)
}

extension RealtimeConversationItem {
    public static func system(_ content: [RealtimeSystemContent]) -> Self {
        return .messages(.system(.init(content: content)))
    }
    public static func system(_ content: RealtimeSystemContent) -> Self {
        return .messages(.system(.init(content: [content])))
    }
    
    public static func user(_ content: [RealtimeUserContent]) -> Self {
        return .messages(.user(.init(content: content)))
    }
    public static func user(_ content: RealtimeUserContent) -> Self {
        return .messages(.user(.init(content: [content])))
    }
    
    public static func assistant(_ content: [RealtimeAssistantContent]) -> Self {
        return .messages(.assistant(.init(content: content)))
    }
    public static func assistant(_ content: RealtimeAssistantContent) -> Self {
        return .messages(.assistant(.init(content: [content])))
    }
}

//
//  RealtimeResponseCreateEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/14/26.
//

import Foundation
import SimpleCodableMacro


// MARK: Output
@BaseModelNoWithExtra
public struct RealtimeResponseAudioOutput {
    public var format: RealtimeAudioFormat
    public var voice: String
}
// MARK: Function Tool
@BaseModelNoWithExtra
public struct RealtimeFunctionTool {
    public static let type: String = "function"
    public var description: String?
    public var name: String?
    public var parameters: BaseType?
}
// MARK: MCP Tool
@BaseModelNoWithExtra
public struct RealtimeAllowedToolsMcpToolFilter {
    public var read_only: Bool?
    public var tool_names: [String]?
}
@SingleOrArray
public enum RealtimeMCPToolAllowedTools {
    case string(String)
    case array([RealtimeAllowedToolsMcpToolFilter])
}
extension RealtimeMCPToolAllowedTools: ExpressibleByStringLiteral, ExpressibleByArrayLiteral {
    public init(stringLiteral value: String)                                 { self = .string(value) }
    public init(arrayLiteral elements: RealtimeAllowedToolsMcpToolFilter...) { self = .array(elements) }
}

@CodableLiteral
public enum RealtimeMCPToolConnectorId: String {
    case connector_dropbox
    case connector_gmail
    case connector_googlecalendar
    case connector_googledrive
    case connector_microsoftteams
    case connector_outlookcalendar
    case connector_outlookemail
    case connector_sharepoint
}
@CodableLiteral
public enum RealtimeMCPToolApprovalFilterLiteral: String {
    case allways, never
}
@BaseModelNoWithExtra
public struct RealtimeMCPToolApprovalFilter {
    public var always: RealtimeAllowedToolsMcpToolFilter?
    public var never: RealtimeAllowedToolsMcpToolFilter?
}
@CodableTraversal
public enum RealtimeMCPToolMcpToolApproval {
    case literal(RealtimeMCPToolApprovalFilterLiteral)
    case filter(RealtimeMCPToolApprovalFilter)
}
@BaseModelNoWithExtra
public struct RealtimeMcpTool {
    public static let type: String = "mcp"
    public var server_label: String
    public var allowed_tools: RealtimeMCPToolAllowedTools?
    public var authorization: String?
    public var connector_id: RealtimeMCPToolConnectorId?
    public var defer_loading: Bool?
    public var headers: [String: String]?
    public var require_approval: RealtimeMCPToolMcpToolApproval?
    public var server_description: String?
    public var server_url: String?
}
// MARK: RealtimeTool
@CodableByConstant
public enum RealtimeResponseTool {
    case function(RealtimeFunctionTool)
    case mcp(RealtimeMcpTool)
}
// MARK: Main
@BaseModelNoWithExtra
public struct RealtimeResponse {
    public var instructions: String?
    public var prompt: ResponsePrompt?
    public var input: [RealtimeConversationItem]?
    public var output: RealtimeResponseAudioOutput?
    public var output_modalities: [RealtimeModalites]?
    public var tool_choice: RealtimeResponseToolChoice?
    public var tools: [RealtimeResponseTool]?
    public var conversation: String?
    public var max_output_tokens: Int?
    public var metadata: OpenAIMetaData?
}

@BaseModelNoWithExtra
public struct RealtimeResponseCreateEventParameters {
    public static let type: String = "response.create"
    public var event_id: String?
    public var response: RealtimeResponse
}

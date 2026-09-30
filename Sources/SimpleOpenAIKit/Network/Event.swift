//
//  Event.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/20/26.
//

import Foundation

/// One server-sent event, as split from the wire by `EventParser`.
///
/// Unused fields stay `nil`; a `nil` `data` means the block carried only a comment or heartbeat.
public struct Event: Sendable {
    public var id: String?
    public var event: String?
    public var data: String?
    public var retry: Int?
}

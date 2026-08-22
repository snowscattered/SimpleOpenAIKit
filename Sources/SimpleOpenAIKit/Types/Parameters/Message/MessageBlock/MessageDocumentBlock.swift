//
//  MessageDocumentBlock.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro


@BaseModelNoWithExtra
public struct MessageDocumentBlock {
    public static let type: String = "document"
    public var source: MessageDocumentBlockSource
    public var cache_control: MessageCacheControlEphemeral?
    public var citations: MessageCitationsConfig?
    public var title: String?
    public var context: String?
}

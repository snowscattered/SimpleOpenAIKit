//
//  MessagePlainTextSource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/7/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct MessagePlainTextSource {
    public static let media_type: String = "text/plain"
    public static let type: String = "text"
    public var data: String
}

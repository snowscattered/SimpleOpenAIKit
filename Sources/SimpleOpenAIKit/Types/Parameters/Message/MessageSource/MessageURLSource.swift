//
//  MessageURLSource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct MessageURLSource {
    public static let type: String = "url"
    public var url: String
}

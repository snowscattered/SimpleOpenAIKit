//
//  MessageURLPDFSource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/7/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct MessageURLPDFSource {
    public static let type: String = "url"
    public var url: String
}

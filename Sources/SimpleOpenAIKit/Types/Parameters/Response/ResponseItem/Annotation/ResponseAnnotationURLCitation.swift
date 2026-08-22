//
//  ResponseAnnotationURLCitation.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ResponseAnnotationURLCitation {
    public static let type: String = "url_citation"
    public var end_index: Int
    public var start_index: Int
    public var title: String
    public var url: String
}

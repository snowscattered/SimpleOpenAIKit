//
//  ResponseVideoContent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ResponseVideoContent {
    public static let type: String = "input_video"
    public var video_url: String
}
extension ResponseVideoContent: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) { self = .init(video_url: value) }
}

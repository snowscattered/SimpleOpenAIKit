//
//  MessageBase64Source.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@CodableLiteral
public enum MessageBase64ImageSourceMidiaType: String {
    case jpeg = "image/jpeg"
    case png = "image/png"
    case gif = "image/gif"
    case webp = "image/webp"
}

@BaseModelNoWithExtra
public struct MessageBase64ImageSource {
    public static let type: String = "base64"
    public var data: String
//    public var media_type: MessageBase64ImageSourceMidiaType
    public var media_type: String
}

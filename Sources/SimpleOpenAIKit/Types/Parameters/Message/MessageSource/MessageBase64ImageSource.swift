//
//  MessageBase64Source.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@CodableStringLiteralWithOther
public enum MessageBase64ImageSourceMidiaType {
    case `image/jpeg`
    case `image/png`
    case `image/gif`
    case `image/webp`
    case other(String)
}

@BaseModelNoWithExtra
@PublicInit
public struct MessageBase64ImageSource {
    public static let type: String = "base64"
    public var data: String
    public var media_type: MessageBase64ImageSourceMidiaType
}

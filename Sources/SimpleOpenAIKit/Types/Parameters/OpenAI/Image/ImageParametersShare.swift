//
//  ImageParametersShare.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/10/26.
//

import Foundation
import SimpleCodableMacro

@CodableLiteral
public enum ImageResponseFormatLiteral: String {
    case url, b64_json
}
@CodableStringLiteralWithOther
public enum ImageOutputFormatLiteral {
    case png, jpeg, webp
    case other(String)
}
@CodableLiteral
public enum ImageBackgroundLiteral: String {
    case transparent, opaque, auto
}

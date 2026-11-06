//
//  ImageParametersShare.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/10/26.
//

import Foundation
import SimpleCodableMacro

@CodableLiteral
public enum ImageResponseFormat: String {
    case url, b64_json
}
@CodableStringLiteralWithOther
public enum ImageOutputFormat {
    case png, jpeg, webp
    case other(String)
}
@CodableLiteral
public enum ImageBackground: String {
    case transparent, opaque, auto
}

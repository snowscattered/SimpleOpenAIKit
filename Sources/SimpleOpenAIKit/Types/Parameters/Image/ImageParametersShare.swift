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
@CodableLiteral
public enum ImageOutputFormatLiteral: String {
    case png, jpeg, webp
}
@CodableLiteral
public enum ImageBackgroundLiteral: String {
    case transparent, opaque, auto
}

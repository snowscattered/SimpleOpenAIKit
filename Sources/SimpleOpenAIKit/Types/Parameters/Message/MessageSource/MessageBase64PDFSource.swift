//
//  MessageBase64PDFSource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/7/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct MessageBase64PDFSource {
    public static let type: String = "base64"
    public static let media_type: String = "application/pdf"
    public var data: String
}

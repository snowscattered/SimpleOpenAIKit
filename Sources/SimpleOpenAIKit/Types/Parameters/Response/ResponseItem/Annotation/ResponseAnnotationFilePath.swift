//
//  ResponseAnnotationFilePath.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ResponseAnnotationFilePath {
    public static let type: String = "file_path"
    public var file_id: String
    public var index: Int
}

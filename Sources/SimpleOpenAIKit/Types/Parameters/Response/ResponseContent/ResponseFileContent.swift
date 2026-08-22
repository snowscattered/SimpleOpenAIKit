//
//  ResponseFileContent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ResponseFileContent {
    public static let type: String = "input_file"
    public var file_data: String
    public var file_url: String
    public var filename: String
    public var file_id: String?
}

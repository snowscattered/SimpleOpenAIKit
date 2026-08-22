//
//  UploadPartResult.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/7/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct UploadPartResult {
    public static let object: String = "upload.part"
    public let id: String
    public let create_at: Int
    public let upload_id: String
}

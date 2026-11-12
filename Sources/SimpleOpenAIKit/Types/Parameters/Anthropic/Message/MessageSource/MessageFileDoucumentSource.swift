//
//  MessageFileDoucumentSource.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/11/11.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct MessageFileDoucumentSource {
    public static let type: String = "file"
    public var file_id: String
}

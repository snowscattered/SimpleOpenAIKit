//
//  VideoCharacterResult.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/11/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct VideoCharacterResult {
    public var id: String?
    public var created_at: Int
    public var name: String?
}

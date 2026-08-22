//
//  PageStruct.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelWithExtra
public struct PageStruct<T: Codable & Sendable> {
    public let data: [T]
    public let has_more: Bool?
}

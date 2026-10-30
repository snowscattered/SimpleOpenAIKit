//
//  PageStruct.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/17/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelWithExtra
@PublicInit
public struct PageStruct<T: Codable & Sendable & Hashable> {
    public let data: [T]
    public let has_more: Bool?
}

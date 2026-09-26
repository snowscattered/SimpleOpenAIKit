//
//  MessageCountTokenResult.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct MessageCountTokenResult {
    public let input_tokens: Int
}

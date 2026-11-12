//
//  VideoCharacterParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/11/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct VideoCharacterCreateParameters {
    public var name: String
    public var video: FileParameters
}

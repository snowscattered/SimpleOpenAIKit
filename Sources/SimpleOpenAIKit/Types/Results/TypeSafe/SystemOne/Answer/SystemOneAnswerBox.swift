//
//  SystemOneAnswerBox.swift
//  SimpleOpenAIKit
//
//  Created by snow on 10/19/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct SystemOneBoxCoordinates {
    public let top: Double
    public let bottom: Double
    public let left: Double
    public let right: Double
}

@BaseModelNoWithExtra
@PublicInit
public struct SystemOneAnswerBox {
    public static let type: String = "box"
    public let box: SystemOneBoxCoordinates
    public let confidence: Double?
}

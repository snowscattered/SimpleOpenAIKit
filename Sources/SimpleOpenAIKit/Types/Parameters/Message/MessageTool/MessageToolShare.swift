//
//  MessageToolShare.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/5/26.
//

import Foundation
import SimpleCodableMacro

@CodableLiteral
public enum MessageAllowedCaller: String {
   case direct
   case code_execution_20250825
   case code_execution_20260120
}
@BaseModelNoWithExtra
public struct MessageUserLocation {
    public static let type: String = "approximate"
    public var city: String?
    public var country: String?
    public var region: String?
    public var timezone: String?
}

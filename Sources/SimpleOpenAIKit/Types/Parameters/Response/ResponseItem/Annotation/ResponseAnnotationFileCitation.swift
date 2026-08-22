//
//  ResponseAnnotationFileCitation.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ResponseAnnotationFileCitation {
    public static let type: String = "file_citation"
    public var file_id: String
    public var filename: String
    public var index: Int
}
    

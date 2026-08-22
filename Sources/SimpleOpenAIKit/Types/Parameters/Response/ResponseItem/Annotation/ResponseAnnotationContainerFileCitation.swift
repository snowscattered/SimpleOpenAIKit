//
//  ResponseAnnotationContainerFileCitation.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct ResponseAnnotationContainerFileCitation {
    public static let type: String = "container_file_citation"
    public var container_id: String
    public var end_index: Int
    public var file_id: String
    public var filename: String
    public var start_index: Int
}

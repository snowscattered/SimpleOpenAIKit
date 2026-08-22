//
//  UploadPartParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/7/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelWithExtra
public struct UploadPartParameters {
    @transient public var upload_id: String
    public var data: FileParameters
}

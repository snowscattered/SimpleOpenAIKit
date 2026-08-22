//
//  UploadParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/7/26.
//

import Foundation
import SimpleCodableMacro

@CodableTraversal
public enum UploadFile {
    case data(Data)
    case url(URL)
}
@BaseModelWithExtra
public struct UploadFileParameters {
    public var file: UploadFile
    public var bytes: Int?
    public var filename: String?
    public var mime_type: String
//    public var purpose: FilesPurposeLiteral,
    public var purpose: String
    public var part_size: Int?
    public var md5: String?
}

@BaseModelWithExtra
public struct UploadCreateParameters {
    public var bytes: Int
    public var filename: String
    public var mime_type: String
//    public var purpose: FilesPurposeLiteral,
    public var purpose: String
    public var expires_after: FilesExpiresAfter?
}

@BaseModelWithExtra
public struct UploadCancelParameters {
    @transient public var upload_id: String
}

@BaseModelWithExtra
public struct UploadCompleParameters {
    @transient public var upload_id: String
    public var part_ids: [String]
    public var md5: String?
}

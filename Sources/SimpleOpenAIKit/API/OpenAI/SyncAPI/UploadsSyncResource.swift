//
//  UploadSyncResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/8/26.
//

import Foundation

public extension OpenAISyncAPIResource.UploadsSyncResource {
    func create(
        parameters: UploadCreateParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> UploadResult {
        let url = try client.getServerUrl(path: "/uploads")
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post,
        )
    }
    
    func cancel(
        upload_id: String,
        requestOptions: RequestOptions? = nil
    ) throws -> UploadResult {
        let url = try client.getServerUrl(path: "/uploads/\(upload_id)/cancel")
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: nil as String?,
            requestOptions: requestOptions,
            client: self.client,
            method: .post,
        )
    }
    
    @discardableResult
    func complete(
        upload_id: String,
        part_ids: [String],
        md5: String? = nil,
        requestOptions: RequestOptions? = nil
    ) throws -> UploadResult {
        let url = try client.getServerUrl(path: "/uploads/\(upload_id)/cancel")
        let parameters = UploadCompleParameters(upload_id: upload_id, part_ids: part_ids, md5: md5)
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post,
        )
    }
    
    func upload_file_chunked(
        parameters: UploadFileParameters
    ) throws -> UploadResult {
        let bytes: Int
        let filename: String
        let inputStream: InputStream
        switch parameters.file {
        case .data(let data):
            guard let b = parameters.bytes else {
                throw OpenAIError.typeError("The `bytes` argument must be given for in-memory files")
            }
            bytes = b
            guard let name = parameters.filename else {
                throw OpenAIError.typeError("The `filename` argument must be given for in-memory files")
            }
            filename = name
            inputStream = InputStream(data: data)
        case .url(let url):
            guard url.isFileURL else {
                throw OpenAIError.invalidUrl
            }
            
            filename = parameters.filename ?? url.lastPathComponent
            if let b = parameters.bytes {
                bytes = b
            } else {
                guard let resourceValues = try? url.resourceValues(forKeys: [.fileSizeKey, .nameKey]),
                        let fileSize = resourceValues.fileSize else {
                    throw OpenAIError.cannotReadFile
                }
                bytes = fileSize
            }
            inputStream = InputStream(url: url)!
        }
        let upload = try self.create(parameters: .init(
            bytes: bytes,
            filename: filename,
            mime_type: parameters.mime_type,
            purpose: parameters.purpose)
        )
        var part_ids: [String] = []
        let part_size = parameters.part_size ?? 64 * 1024 * 1024
        try inputStream.with {
            while true {
                let chunk = inputStream.read(size: part_size)
                if chunk.isEmpty { break }
                let part = try self.part.create(
                    upload_id: upload.id,
                    parameters: .init(data: chunk)
                )
                part_ids.append(part.id)
            }
        }
        return try self.complete(upload_id: upload.id, part_ids: part_ids)
    }
}

public extension OpenAISyncAPIResource.UploadsPartSyncResource {
    func create(
        upload_id: String,
        parameters: FileParameters,
        requestOptions: RequestOptions? = nil
    ) throws -> UploadPartResult {
        let url = try client.getServerUrl(path: "/uploads/\(upload_id)/cancel")
        return try OpenAISession.shared.SyncResponse(
            url,
            payload: parameters,
            requestOptions: requestOptions,
            client: self.client,
            method: .post,
            hasFile: true
        )
    }
}

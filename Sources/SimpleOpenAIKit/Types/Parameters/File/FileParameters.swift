//
//  FileParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

#if canImport(UniformTypeIdentifiers)
import UniformTypeIdentifiers
func getMimeType(for url: URL) -> String? {
    return UTType(filenameExtension: url.pathExtension)?.preferredMIMEType
}
#else
private let mimeTypeMapping: [String: String] = [
    // 文本
    "txt":  "text/plain",
    "html": "text/html",
    "htm":  "text/html",
    "css":  "text/css",
    "js":   "application/javascript",
    "json": "application/json",
    "xml":  "application/xml",
    "csv":  "text/csv",
    "md":   "text/markdown",

    // 图像
    "jpg":  "image/jpeg",
    "jpeg": "image/jpeg",
    "png":  "image/png",
    "gif":  "image/gif",
    "bmp":  "image/bmp",
    "svg":  "image/svg+xml",
    "webp": "image/webp",
    "ico":  "image/x-icon",
    "tiff": "image/tiff",
    "tif":  "image/tiff",

    // 音频
    "mp3":  "audio/mpeg",
    "wav":  "audio/wav",
    "aac":  "audio/aac",
    "flac": "audio/flac",
    "ogg":  "audio/ogg",
    "m4a":  "audio/mp4",

    // 视频
    "mp4":  "video/mp4",
    "avi":  "video/x-msvideo",
    "mov":  "video/quicktime",
    "wmv":  "video/x-ms-wmv",
    "flv":  "video/x-flv",
    "mkv":  "video/x-matroska",
    "webm": "video/webm",

    // 应用 / 文档
    "pdf":  "application/pdf",
    "doc":  "application/msword",
    "docx": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    "xls":  "application/vnd.ms-excel",
    "xlsx": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    "ppt":  "application/vnd.ms-powerpoint",
    "pptx": "application/vnd.openxmlformats-officedocument.presentationml.presentation",
    "zip":  "application/zip",
    "rar":  "application/vnd.rar",
    "7z":   "application/x-7z-compressed",
    "tar":  "application/x-tar",
    "gz":   "application/gzip",

    // 代码 / 脚本
    "sh":    "application/x-sh",
    "swift": "text/x-swift",
    "java":  "text/x-java",
    "py":    "text/x-python",
    "c":     "text/x-c",
    "cpp":   "text/x-c++",
    "h":     "text/x-c-header",

    // 其他
    "rtf":  "application/rtf",
    "log":  "text/plain",
    "plist": "application/x-plist",
    "dmg":  "application/x-apple-diskimage"
]
func getMimeType(for url: URL) -> String? {
    let ext = url.pathExtension.lowercased()
    return mimeTypeMapping[ext]
}
#endif

// MARK: - FileParameters
#if SelectInputStream
public struct FileParameters: @unchecked Sendable {
    public var raw: InputStream
    public var name: String = "upload"
    public var mimeType: String = "application/octet-stream"
    public let size: Int
}
extension FileParameters {
    public init(url: URL) throws {
        #if HasNetWorkURL
        let stream: InputStream
        if url.isFileURL {
            guard let s = InputStream(url: url) else { throw IOStreamError.streamCreationFailed }
            stream = s
        } else {
             stream = NetworkInputStream(url: url)
        }
        #else
        guard url.isFileURL else { throw IOStreamError.invalidURL }
        guard let stream = InputStream(url: url) else { throw IOStreamError.creationFailed }
        #endif
        self = .init(
            raw: stream,
            name: url.lastPathComponent,
            mimeType: getMimeType(for: url) ?? "application/octet-stream",
            size: try url.resourceValues(forKeys: [.fileSizeKey]).fileSize ?? 0
        )
    }
    public init(data: Data, name: String = "upload", mimeType: String = "application/octet-stream") {
        self = .init(
            raw: InputStream(data: data),
            name: name,
            mimeType: mimeType,
            size: data.count
        )
    }
}
nonisolated extension FileParameters: BaseModel {
    private enum CodingKeys: String, CodingKey {
        case raw
        case name
        case mimeType
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.decode(Data.self, forKey: .raw)
        self.name = try container.decode(String.self, forKey: .name)
        self.raw = InputStream(data: data)
        self.mimeType = try container.decode(String.self, forKey: .mimeType)
        self.size = data.count
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var data: Data = Data()
        self.raw.with {
            data = raw.read()
        }
        try container.encode(data, forKey: .raw)
        try container.encode(name, forKey: .name)
        try container.encode(mimeType, forKey: .mimeType)
    }
}
#else
@BaseModelNoWithExtra
public struct FileParameters {
    public var raw: Data
    public var name: String = "upload"
    public var mimeType: String = "application/octet-stream"
}
extension FileParameters {
    public init(data: Data, name: String = "upload", mimeType: String = "application/octet-stream") {
        self = .init(
            raw: data,
            name: name,
            mimeType: mimeType
        )
    }
    
    public init(url: URL) throws {
        var data: Data = Data()
        #if HasNetWorkURL
        let stream: InputStream
        if url.isFileURL {
            data = try Data(contentsOf: url)
        } else {
            guard let stream = InputStream(url: url) else { throw FileParametersError.cannotCreateInputStream }
            stream.with {
                data = stream.read()
            }
        }
        #else
        guard url.isFileURL else { throw FileParametersError.invalidFileURL }
        data = try Data(contentsOf: url)
        #endif
        self = .init(
            raw: data,
            name: url.lastPathComponent,
            mimeType: getMimeType(for: url) ?? "application/octet-stream"
        )
    }
}
#endif

// MARK: - Create
@CodableLiteral
public enum FilesPurposeLiteral: String {
    case assistants
    case assistants_output
    case batch
    case batch_output
    case fine_tune = "fine-tune"
    case fine_tune_results = "fine-tune-results"
    case vision
    case user_data
}
@BaseModelNoWithExtra
public struct FilesExpiresAfter {
    public static let anchor: String = "created_at"
    public var seconds: Int
}
@BaseModelWithExtra
public struct FilesCreateParameters {
    public var file: FileParameters
//    public var purpose: FilesPurposeLiteral?
    public var purpose: String?
    public var expires_after: FilesExpiresAfter?
}

// MARK: - List
@CodableLiteral
public enum ListOrder: String {
    case asc
    case desc
}
@BaseModelWithExtra
public struct FilesListParameters {
    public var after: String?
    public var limit: Int?
    public var order: ListOrder?
    public var purpose: String?
}

// MARK: - Retrieve
@BaseModelWithExtra
public struct FilesRetrieveParameter {
    @transient public var file_id: String
}

// MARK: - Delete
@BaseModelWithExtra
public struct FilesDeleteParameter {
    @transient public var file_id: String
}

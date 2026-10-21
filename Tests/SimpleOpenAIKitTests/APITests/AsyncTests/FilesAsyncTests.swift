//
//  FilesAsyncTests.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/13/26.
//

import Testing
import Foundation
import SimpleCodableMacro
import UniformTypeIdentifiers
@testable import SimpleOpenAIKit

@Suite("FilesAsyncTests")
struct FilesAsyncTests {
    func makeParameter() throws -> FilesCreateParameters {
        let url = try #require(bundle.url(forResource: "TextTest", withExtension: "txt"))
        return .init(
            file: try .init(url: url),
            purpose: .other("file-extract"),
        )
    }
    @Test func FileStream() async throws {
        let encoder = MultipartFormDataEncodeContainer()
        try encoder.encode(makeParameter())
        let stream = encoder.serialize
        stream.with {
            let data = stream.read()
            print(data.count)
            print(String(data: data, encoding: .utf8)!)
        }
    }
    
    @Test func asyncFileCreate() async throws {
        let res = try await asyncClient.files.create(
            parameters: makeParameter()
        )
        print(res)
    }
    @Test func asyncFileList() async throws {
        let res = try await asyncClient.files.list()
        for try await value in res {
            for i in value.data {
                print(i)
            }
        }
    }
    @Test func asyncFileRetrieve() async throws {
        let res = try await asyncClient.files.retrieve(file_id: "file-fe-0...")
        print(res)
    }
    
    @Test func asyncFileDelete() async throws {
        let res = try await asyncClient.files.delete(file_id: "file-fe-0...")
        print(res)
    }
    
}


func multipartDebugText(_ data: Data, boundary: String) -> String {
    let boundaryData = Data("--\(boundary)".utf8)
    let headerSeparator = Data("\r\n\r\n".utf8)
    let crlf = Data("\r\n".utf8)

    var boundaryRanges: [Range<Data.Index>] = []
    var searchStart = data.startIndex
    while let range = data.range(of: boundaryData, in: searchStart..<data.endIndex) {
        boundaryRanges.append(range)
        searchStart = range.upperBound
    }

    guard !boundaryRanges.isEmpty else {
        return String(decoding: data, as: UTF8.self)
    }

    var result = ""
    for (index, boundaryRange) in boundaryRanges.enumerated() {
        let sectionEnd = boundaryRanges.indices.contains(index + 1)
            ? boundaryRanges[index + 1].lowerBound
            : data.endIndex
        let section = data[boundaryRange.lowerBound..<sectionEnd]

        guard
            index + 1 < boundaryRanges.count,
            let headerEnd = data.range(of: headerSeparator, in: boundaryRange.upperBound..<sectionEnd)
        else {
            result += String(decoding: section, as: UTF8.self)
            continue
        }

        let header = data[boundaryRange.lowerBound..<headerEnd.upperBound]
        let headerText = String(decoding: header, as: UTF8.self)
        guard headerText.localizedCaseInsensitiveContains("filename=") else {
            result += String(decoding: section, as: UTF8.self)
            continue
        }

        var fileData = data[headerEnd.upperBound..<sectionEnd]
        if fileData.count >= 2, fileData.suffix(2).elementsEqual(crlf) {
            fileData = fileData.dropLast(2)
        }
        let prefix = fileData.prefix(4)
            .map { String(format: "%02X", $0) }
            .joined(separator: " ")
        let byteKind: String
        if fileData.starts(with: [0x89, 0x50, 0x4E, 0x47]) {
            byteKind = "PNG"
        } else if fileData.starts(with: [0xFF, 0xD8, 0xFF]) {
            byteKind = "JPEG"
        } else {
            byteKind = "文件"
        }
        let placeholder = byteKind == "文件"
            ? "<原始文件字节 \(prefix) ...>"
            : "<原始 \(byteKind) 字节 \(prefix) ...>"

        result += headerText
        result += placeholder
        result += "\r\n"
    }

    return result.replacingOccurrences(of: "\r\n", with: "\n")
}

//
//  FilesSyncTests.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/13/26.
//

import Testing
import Foundation
import SimpleCodableMacro
import UniformTypeIdentifiers
@testable import SimpleOpenAIKit

@Suite("FilesSyncTests")
struct FilesSyncTests {
    func makeRequest() throws -> FilesCreateParameters {
        let url = try #require(bundle.url(forResource: "TextTest", withExtension: "txt"))
        return .init(
            file: try .init(url: url),
            purpose: "file-extract",
        )
    }
    
    @Test func syncFileCreate() throws {
        let res = try client.files.create(
            parameters: makeRequest()
        )
        print(res)
    }
    
    @Test func syncFileList() throws {
        let res = try client.files.list(
            parameters: .init(limit: 5)
        )
        try res.forEach { value in
            for i in value.data {
                print(i)
            }
        }
    }
    @Test func syncFileRetrieve() throws {
        let res = try client.files.retrieve(file_id: "file-fe-0...")
        print(res)
    }
    
    @Test func syncFileDelete() throws {
        let res = try client.files.delete(file_id: "file-fe-0...")
        print(res)
    }
    
}

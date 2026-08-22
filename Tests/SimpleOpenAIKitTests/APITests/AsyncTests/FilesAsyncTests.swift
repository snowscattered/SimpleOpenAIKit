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
            purpose: "file-extract",
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

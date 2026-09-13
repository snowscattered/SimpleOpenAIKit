//
//  CodableStringLiteralWithOtherTest.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/13/26.
//

import Foundation
import Testing
import SimpleCodableMacro

@Suite struct CodableStringLiteralTests {
    @Test("CodableStringLiteralWithOther Using") func CodableStringLiteralMacroTests() throws {
        let x: CodableStringLiteralStruct = .`a-b`
        let encoded = try JSONEncoder().encode(x)
        let json = String(data: encoded, encoding: .utf8)!
        print(json)
        
        let decoded = try JSONDecoder().decode(CodableStringLiteralStruct.self, from: encoded)
        print(decoded)
    }
}

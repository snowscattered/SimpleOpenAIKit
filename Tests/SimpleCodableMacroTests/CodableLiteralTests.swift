//
//  CodableLiteralTests.swift
//  SimpleCodableMacroTests
//
//  Created by snow on 9/10/26.
//

import Foundation
import Testing
import SimpleCodableMacro

@Suite struct CodableLiteralTests {
    @Test("CodableLiteral Using") func CodableLiteralMacroTest() async throws {
        do {
            let s = "150"
            let literal: IntLiteral = try JSONDecoder().decode(IntLiteral.self ,from: s.data(using: .utf8)!)
            print(literal)
        } catch { print(error) }

        let S: StringLiteral = .`A-A`
        try print(String(decoding: JSONEncoder().encode(S), as: UTF8.self))
        try print(JSONDecoder().decode(StringLiteral.self, from: #""A-A""#.data(using: .utf8)!))
    }
}

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
            let literal: Literal = try JSONDecoder().decode(Literal.self ,from: s.data(using: .utf8)!)
            print(literal)
        } catch { print(error) }
    }
}

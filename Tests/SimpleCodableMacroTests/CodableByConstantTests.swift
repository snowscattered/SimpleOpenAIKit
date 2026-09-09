//
//  CodableByConstantTests.swift
//  SimpleCodableMacroTests
//
//  Created by snow on 9/10/26.
//

import Foundation
import Testing
import SimpleCodableMacro

@Suite struct CodableByConstantTests {
    @Test("CodableByConstant Using") func CodableByConstantMacroTest() throws {
        let CodableByConstantJson = #"""
        {
            "role": "A",
            "name": "N"
        }
        """#
        let x = try JSONDecoder().decode(X.self, from: CodableByConstantJson.data(using: .utf8)!)
        print(x)
        let y = try JSONEncoder().encode(x)
        print(String(data: y, encoding: .utf8)!)
    }
}
